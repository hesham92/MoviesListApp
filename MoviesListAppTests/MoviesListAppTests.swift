import Foundation
import Combine
import Testing
@testable import MoviesListApp

struct MoviesListAppTests {

//    @Test func testInitialStateIsLoading() async throws {
//        let viewModel = MovieDetailsViewModel(movieItemDetails: makeMockMovieItem())
//        #expect(viewModel.state == .loading)
//    }
//
//    @Test func testLoadDataUpdatesStateToLoaded() async throws {
//        let viewModel = MovieDetailsViewModel(movieItemDetails: makeMockMovieItem())
//
//        let stateStream = AsyncStream(of: MovieDetailsViewModel.MovieDetailsViewState.self) { continuation in
//            let cancellable = viewModel.$state
//                .sink { newState in continuation.yield(newState) }
//            continuation.onTermination = { _ in cancellable.cancel() }
//        }
//
//        viewModel.viewDidAppear()
//
//        for try await state in stateStream {
//            if case .loaded(let sections) = state {
//                #expect(sections.count == 2)
//                break
//            }
//        }
//    }

    // MARK: - Mock Data
    func makeMockMovieItem() -> MovieItemDetails {
        return MovieItemDetails(
            id: 1,
            title: "Mock Movie",
            overview: "A test overview of the movie.",
            releaseDate: "2023-01-01",
            posterPath: "/mockPosterPath.jpg",
            homepage: "https://example.com",
            budget: 100000,
            revenue: 500000,
            runtime: 120,
            status: "Released",
            genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Drama")],
            spokenLanguages: [SpokenLanguage(englishName: "English", name: "English")]
        )
    }
}

