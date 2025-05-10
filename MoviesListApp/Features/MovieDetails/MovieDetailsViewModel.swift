import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    enum MovieDetailsViewState {
        case loading
        case error(String)
        case loaded(MovieItemDetails)
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
                if let movie = movie {
                    self?.state = .loaded(movie)
                } else {
                    self?.state = .empty
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

    // Computed Properties

    var formattedTitle: String {
        guard case .loaded(let movie) = state else { return "" }
        return "\(movie.title) (\(movie.releaseDate))"
    }

    var formattedGenres: String {
        guard case .loaded(let movie) = state, !movie.genres.isEmpty else { return "" }
        return movie.genres.map { $0.name }.joined(separator: ", ")
    }

    var overviewText: String {
        guard case .loaded(let movie) = state else { return "" }
        return movie.overview
    }

    var posterPath: String? {
        guard case .loaded(let movie) = state else { return nil }
        return movie.posterPath
    }

    var budgetText: String {
        guard case .loaded(let movie) = state else { return "" }
        return "Budget: \(movie.budget.formatted(.currency(code: "USD")))"
    }

    var statusText: String {
        guard case .loaded(let movie) = state else { return "" }
        return "Status: \(movie.status)"
    }

    var runtimeText: String {
        guard case .loaded(let movie) = state else { return "" }
        return "Runtime: \(movie.runtime) minutes"
    }

    var revenueText: String {
        guard case .loaded(let movie) = state else { return "" }
        return "Revenue: \(movie.revenue.formatted(.currency(code: "USD")))"
    }

    var homepageText: String? {
        guard case .loaded(let movie) = state else { return nil }
        return "Homepage: \(movie.homepage)"
    }

    var languagesText: String? {
        guard case .loaded(let movie) = state, !movie.spokenLanguages.isEmpty else { return nil }
        return "Languages: \(movie.spokenLanguages.map { $0.name }.joined(separator: ", "))"
    }
}
