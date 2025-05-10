import Foundation
import Combine
import SwiftData

@MainActor
class MoviesListViewModel: ObservableObject {
    
    enum MoviesListViewState {
        case loading
        case error(String)
        case loaded([MovieItemViewPresentation])
        case empty
    }

    @Published var state: MoviesListViewState = .loading
    @Published var selectedFilter: String = "All" {
        didSet {
           // applyFilter()
        }
    }

    private var allMovies: [MovieItemDetails] = []
    private var totalPages = 10
    private var currentPage = 1
    private var isConnected: Bool = true

    private let repository: MoviesListRepository
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()

    init(
        context: ModelContext,
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.repository = MoviesListRepository(context: context)
        self.networkMonitor = networkMonitor
    }

    func viewDidAppear() {
        bindPublishers()
    }

    func loadData() {
        guard currentPage <= totalPages else { return }
        state = .loading
        repository.loadMoviesListData(page: currentPage, isOnline: isConnected)
    }

    private func bindPublishers() {
        networkMonitor.$isConnected
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                isConnected = status
                loadData()
            }
            .store(in: &cancellables)

        repository.$movies
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.allMovies += data
                self.currentPage += 1
                state = .loaded(allMovies.map { MovieItemViewPresentation(movieItem: $0) })
            }
            .store(in: &cancellables)

        repository.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.state = .error(error)
            }
            .store(in: &cancellables)

        repository.$totalPages
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pages in
                self?.totalPages = pages
            }
            .store(in: &cancellables)
    }

//    private func applyFilter() {
//        let filtered: [MovieItemDetails]
//        if selectedFilter == "All" {
//            filtered = allMovies
//        } else {
//            filtered = allMovies.filter { $0.genre == selectedFilter }
//        }
//
//        if filtered.isEmpty {
//            state = .empty
//        } else {
//            let presentations = filtered.map { MovieItemViewPresentation(movieItem: $0) }
//            state = .loaded(presentations)
//        }
//    }
}


import Foundation

struct MovieItemViewPresentation: Hashable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    
    init(movieItem: MovieItemDetails) {
        self.movieItem = movieItem
        self.id = movieItem.id
        self.title = movieItem.title
        self.releaseDate = movieItem.releaseDate
        self.posterPath = movieItem.posterPath
    }
    
    let movieItem: MovieItemDetails
}





