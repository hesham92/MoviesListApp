import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    enum MovieItemDetailsSection: Hashable {
        case poster(String)
        case header(MovieDetailsHeaderViewPresentation)
        case content(MovieDetailsContentViewPresentation)
    }
    
    enum MovieDetailsViewState {
        case loading
        case error(String)
        case loaded([MovieItemDetailsSection])
        case empty
    }

    @Published var state: MovieDetailsViewState = .loading

    private let repository: MovieDetailsRepository
    private var cancellables = Set<AnyCancellable>()

    init(movieId: Int) {
        self.repository = MovieDetailsRepository(movieId: movieId)
    }

    func viewDidAppear() {
        loadData()
    }

    func loadData() {
        state = .loading
        repository.loadMovieDetails()
        bindPublishers()
    }

    private func bindPublishers() {
        // Bind repository to state
        repository.$movie
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                guard let self else { return }
                
                if let movie = movie {
                    self.state = .loaded(makeMovieItemDetailsSections(from: movie))
                } else {
                    self.state = .empty
                }
            }
            .store(in: &cancellables)

        repository.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.state = .loading
                }
            }
            .store(in: &cancellables)

        repository.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.state = .error(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func makeMovieItemDetailsSections(from movieItem: MovieItemDetails) -> [MovieItemDetailsSection] {
        [
            .poster(movieItem.posterPath),
            .header(MovieDetailsHeaderViewPresentation(movieItem: movieItem)),
            .content(MovieDetailsContentViewPresentation(movieItem: movieItem))
        ]
    }
}
