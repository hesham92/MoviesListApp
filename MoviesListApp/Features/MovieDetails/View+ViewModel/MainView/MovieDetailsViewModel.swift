import Foundation
import Combine
import SwiftData
import Factory

class MovieDetailsViewModel: ObservableObject {
    enum MovieItemDetailsSection: Hashable {
        case header(MovieDetailsHeaderViewPresentation)
        case content(MovieDetailsContentViewPresentation)
    }
    
    enum MovieDetailsViewState: Equatable {
        case loading
        case error(String)
        case loaded([MovieItemDetailsSection])
        case empty
    }

    @Published var state: MovieDetailsViewState = .loading

    private var cancellables = Set<AnyCancellable>()

    init(movieItemId: Int) {
        self.movieItemId = movieItemId
    }

    func viewDidAppear() {
        loadData()
    }
    
    func loadData() {
        repository.fetchMovieDetails(for: movieItemId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("zss")
                case .failure(_):
                    print("zss")
                }
            }, receiveValue: { [weak self] movieItemDetails in
                guard let self = self else { return }
                state = .loaded(makeMovieItemDetailsSections(from: movieItemDetails))
            })
            .store(in: &cancellables)
    }
    
    private func makeMovieItemDetailsSections(from movieItem: MovieItemDetails) -> [MovieItemDetailsSection] {
        [
            .header(MovieDetailsHeaderViewPresentation(movieItem: movieItem)),
            .content(MovieDetailsContentViewPresentation(movieItem: movieItem))
        ]
    }
    
    private let movieItemId: Int
    @Injected(\.moviesListRepository) private var repository
}
