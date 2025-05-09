import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var movie: MovieItemDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let repository: MovieDetailsRepository
    private var cancellables = Set<AnyCancellable>()

    init(movieId: Int) {
        self.repository = MovieDetailsRepository(movieId: movieId)
    }

    func viewDidAppear() {
        bindPublishers()
        loadData()
    }

    func loadData() {
        isLoading = true
        errorMessage = nil
        repository.loadMovieDetails()
    }

    private func bindPublishers() {
        repository.$movie
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                self?.movie = movie
            }
            .store(in: &cancellables)

        repository.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        repository.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Preformatted UI Strings

    var formattedTitle: String {
        guard let movie else { return "" }
        return "\(movie.title) (\(movie.releaseDate))"
    }

    var formattedGenres: String {
        guard let movie, !movie.genres.isEmpty else { return "" }
        return movie.genres.map { $0.name }.joined(separator: ", ")
    }

    var overviewText: String {
        movie?.overview ?? ""
    }

    var posterPath: String? {
        movie?.posterPath
    }

    var budgetText: String {
        guard let movie else { return "" }
        return "Budget: \(movie.budget.formatted(.currency(code: "USD")))"
    }

    var statusText: String {
        guard let movie else { return "" }
        return "Status: \(movie.status)"
    }

    var runtimeText: String {
        guard let runtime = movie?.runtime else { return "" }
        return "Runtime: \(runtime) minutes"
    }

    var revenueText: String {
        guard let movie else { return "" }
        return "Revenue: \(movie.revenue.formatted(.currency(code: "USD")))"
    }

    var homepageText: String? {
        guard let homepage = movie?.homepage else { return nil }
        return "Homepage: \(homepage)"
    }

    var languagesText: String? {
        guard let movie, !movie.spokenLanguages.isEmpty else { return nil }
        return "Languages: \(movie.spokenLanguages.map { $0.name }.joined(separator: ", "))"
    }
}

