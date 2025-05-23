import Foundation
import Combine
import SwiftData
import Factory
import OrderedCollections

class MoviesListViewModel: ObservableObject {
    struct MovieListItemViewPresentation: Equatable {
        let moviesItemsList: OrderedSet<MovieItemViewPresentation>
        let filterList: [Genre]
    }
    
    enum MoviesListViewState: Equatable {
        case loading
        case error(String)
        case loaded(MovieListItemViewPresentation, isLoading: Bool)
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
        
        mutating func setLoading() {
            switch self {
            case .loading, .error, .empty:
                self = .loading
            case let .loaded(model, _):
                self = .loaded(model, isLoading: true)
            }
        }
    }

    @Injected(\.moviesListRepository) private var repository
    
    @Published private(set) var state: MoviesListViewState = .loading
    @Published var selectedFilter: Genre?
    @Published private var currentPage = 1
    
    private var movieItems: OrderedSet<MovieItemViewPresentation> = []
    private var filterList: [Genre] = []
    private var totalPages = 0
    private var cancellables = Set<AnyCancellable>()

    func viewDidAppear() {
        bindPublishers()
    }

    func loadData() {
        guard currentPage <= totalPages, !state.isLoading else { return }
        
        currentPage += 1
        state.setLoading()
    }

    private func bindPublishers() {
        Publishers.CombineLatest3(
            $currentPage
                .removeDuplicates()
                .flatMap { [repository] page in
                    repository.loadMoviesListData(page: page)
                },
            repository.fetchGenres(),
            $selectedFilter.setFailureType(to: Error.self)
        )
        .asResult()
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let (movies, filters, selectedFilter) = response
                totalPages = movies.totalPages
                movieItems.append(contentsOf: movies.results.map { MovieItemViewPresentation(movieItem: $0) })
                filterList = filters.genres
                
                state = .loaded(
                    MovieListItemViewPresentation(
                        moviesItemsList: movieItems.filter{
                            guard let selectedFilter else { return true }
                            return $0.movieItem.genreIds.contains(selectedFilter.id)
                        },
                        filterList: filterList
                    ),
                    isLoading: false
                )
                
            case .failure(let error):
                state = .error(error.localizedDescription)
            }
        })
        .store(in: &cancellables)
    }
}

