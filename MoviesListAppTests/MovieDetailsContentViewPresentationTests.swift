import XCTest
import Combine
import Factory
@testable import MoviesListApp

class MovieDetailsContentViewPresentationTests: XCTestCase {
    var presentation: MovieDetailsContentViewPresentation!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        presentation = nil
        super.tearDown()
    }

    func testBudgetText() {
        presentation = MovieDetailsContentViewPresentation(movieItem: MovieItemDetails.mock(budget: 100))

        XCTAssertEqual(presentation.budgetText, "Budget: 100 $")
    }

    func testStatusText() {
        presentation = MovieDetailsContentViewPresentation(movieItem: MovieItemDetails.mock(status: "Released"))

        XCTAssertEqual(presentation.statusText, "Status: Released")
    }

    func testRuntimeText() {
        presentation = MovieDetailsContentViewPresentation(movieItem: MovieItemDetails.mock(runtime: 120))

        XCTAssertEqual(presentation.runtimeText, "Runtime: 120 minutes")
    }

    func testRevenueText() {
        presentation = MovieDetailsContentViewPresentation(movieItem: MovieItemDetails.mock(revenue: 30000))

        XCTAssertEqual(presentation.revenueText, "Revenue: 30000 $")
    }
}

extension MovieItemDetails {
    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "A thrilling adventure.",
        releaseDate: String = "2025-05-01",
        posterPath: String = "/poster/path.jpg",
        homepage: String = "https://www.example.com",
        budget: Int = 100000000,
        revenue: Int = 300000000,
        runtime: Int = 120,
        status: String = "Released",
        genres: [Genre] = [Genre(id: 1, name: "Action")],
        spokenLanguages: [SpokenLanguage] = [SpokenLanguage(englishName: "English", name: "en")]
    ) -> MovieItemDetails {
        return MovieItemDetails(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            homepage: homepage,
            budget: budget,
            revenue: revenue,
            runtime: runtime,
            status: status,
            genres: genres,
            spokenLanguages: spokenLanguages
        )
    }
}
