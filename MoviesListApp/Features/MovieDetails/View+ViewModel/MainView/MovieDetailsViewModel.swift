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

    @Injected(\.moviesListRepository) private var repository
    @Published var state: MovieDetailsViewState = .loading
    
    private var cancellables = Set<AnyCancellable>()
    private let movieItemId: Int

    init(movieItemId: Int) {
        self.movieItemId = movieItemId
    }

    func viewDidAppear() {
        loadData()
    }
    
    func loadData() {
        repository.fetchMovieDetails(for: movieItemId)
            .receive(on: DispatchQueue.main)
            .asResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let movieItemDetails):
                    state = .loaded(makeMovieItemDetailsSections(from: movieItemDetails))
                    
                case .failure(let error):
                    state = .error(error.localizedDescription)
                }
            })
            .store(in: &cancellables)
    }
    
    private func makeMovieItemDetailsSections(from movieItem: MovieItemDetails) -> [MovieItemDetailsSection] {
        [
            .header(MovieDetailsHeaderViewPresentation(movieItem: movieItem)),
            .content(MovieDetailsContentViewPresentation(movieItem: movieItem))
        ]
    }
}
