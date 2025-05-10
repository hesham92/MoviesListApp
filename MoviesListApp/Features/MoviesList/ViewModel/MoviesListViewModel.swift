import Foundation
import Combine
import SwiftData

@MainActor
class MoviesListViewModel: ObservableObject {
    enum MoviesListViewState: Equatable {
        case loading
        case error(String)
        case loaded([MovieItemViewPresentation], isLoading: Bool)
        case empty
        
        var isLoading: Bool {
            switch self {
            case .loading:
                true
            case .error(_):
                false
            case .loaded(_, isLoading: let isLoading):
                isLoading
            case .empty:
                false
            }
        }
    }

    @Published var state: MoviesListViewState = .loading
    @Published var selectedFilter: String = "All" {
        didSet {
            // applyFilter()
        }
    }

    @Published private var currentPage = 1
    @Published var movieItems: [MovieItemViewPresentation] = []

    private var totalPages = 10
    private let repository: MoviesListRepository
    private var cancellables = Set<AnyCancellable>()

    init(
        context: ModelContext
    ) {
        self.repository = MoviesListRepository(context: context)
    }

    func viewDidAppear() {
        bindPublishers()
        loadData()
    }

    func loadData() {
        guard currentPage <= totalPages, !state.isLoading else { return }
        
        currentPage += 1
        state = .loaded(movieItems, isLoading: true)
    }

    private func bindPublishers() {
        $currentPage
            .removeDuplicates()
            .flatMap { [repository] page in
                let res = repository.loadMoviesListData(page: page)
                    .catch { error in
                        
                        Just(MovieItemListResponse(page: 0, totalResults: 0, totalPages: 0, results: []))
                    }
                return res
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.movieItems += response.results.map { MovieItemViewPresentation(movieItem: $0) }
                state = .loaded(movieItems, isLoading: false)
            }
            .store(in: &cancellables)
    }

    // private func applyFilter() { ... }
}



import Foundation

struct MovieItemViewPresentation: Hashable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    
    init(movieItem: MovieItem) {
        self.movieItem = movieItem
        self.id = movieItem.id
        self.title = movieItem.title
        self.releaseDate = movieItem.releaseDate
        self.posterPath = movieItem.posterPath
    }
    
    let movieItem: MovieItem
}





