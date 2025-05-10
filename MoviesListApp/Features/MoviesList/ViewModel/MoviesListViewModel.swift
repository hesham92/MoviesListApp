import Foundation
import Combine
import SwiftData
import Factory
import OrderedCollections

@MainActor
class MoviesListViewModel: ObservableObject {
    enum MoviesListViewState: Equatable {
        case loading
        case error(String)
        case loaded(OrderedSet<MovieItemViewPresentation>, isLoading: Bool)
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
    @Published var movieItems: OrderedSet<MovieItemViewPresentation> = []

    private var totalPages = 10
    private var cancellables = Set<AnyCancellable>()
    
    @Injected(\.moviesListRepository) private var repository

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
                 repository.loadMoviesListData(page: page)
            }
            .asResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    self.movieItems.append(contentsOf: response.results.map { MovieItemViewPresentation(movieItem: $0) })
                    state = .loaded(movieItems, isLoading: false)
                    
                case .failure(let error):
                    state = .error(error.localizedDescription)
                }
            })
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


extension Publisher {
  func asResult() -> some Publisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
  }
}


