import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    enum MovieItemDetailsSection: Hashable {
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

    private var cancellables = Set<AnyCancellable>()

    init(movieItemDetails: MovieItemDetails) {
        self.movieItemDetails = movieItemDetails
    }

    func viewDidAppear() {
        loadData()
    }

    func loadData() {
        state = .loaded(makeMovieItemDetailsSections(from: movieItemDetails))
    }
    
    private func makeMovieItemDetailsSections(from movieItem: MovieItemDetails) -> [MovieItemDetailsSection] {
        [
            .header(MovieDetailsHeaderViewPresentation(movieItem: movieItem)),
            .content(MovieDetailsContentViewPresentation(movieItem: movieItem))
        ]
    }
    
    private let movieItemDetails: MovieItemDetails
}
