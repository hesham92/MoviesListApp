import XCTest
import Combine
import Factory
@testable import MoviesListApp

final class MoviesListViewModelTests: XCTestCase {
    var viewModel: MoviesListViewModel!
    var repository: MockMoviesListRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        
        repository = MockMoviesListRepository()
        Container.shared.moviesListRepository.register { self.repository }
        viewModel = MoviesListViewModel()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        repository = nil
        cancellables = nil
        
        super.tearDown()
    }

    func test_initialState_isLoading() {
        XCTAssertEqual(viewModel.state, .loading)
    }

    func test_loadData_success() {
        let movie = MovieItem(id: 1, title: "Test", releaseDate: "2023-01-01", posterPath: "/path", genreIds: [])
        let response = MovieItemListResponse(totalPages: 100, results: [movie])
        repository.result = .success(response)

        let expectation = self.expectation(description: "Load success")

        viewModel.viewDidAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .loaded(presentations, isLoading) = self.viewModel.state {
                XCTAssertEqual(presentations.moviesItemsList.count, 1)
                XCTAssertFalse(isLoading)
            } else {
                XCTFail("Expected error state")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_loadData_failure() {
        repository.result = .failure(NSError(domain: "TestError", code: -1, userInfo: nil))

        let expectation = self.expectation(description: "Load failure")

        viewModel.viewDidAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case .error(let message) = self.viewModel.state {
                XCTAssertTrue(message.contains("TestError"))
            } else {
                XCTFail("Expected error state")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_loadData_incrementCurrentPage() {
        let movie = MovieItem(id: 1, title: "Test", releaseDate: "2023-01-01", posterPath: "/path", genreIds: [])
        let response = MovieItemListResponse(totalPages: 100, results: [movie])
        repository.result = .success(response)

        let expectation = self.expectation(description: "Load success")

        viewModel.viewDidAppear() // Initial Call
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.loadData() // Simulate call second page
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.repository.recievedPage, 2)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockMoviesListRepository: MoviesListRepository {
    var result: Result<MovieItemListResponse, Error> = .success(MovieItemListResponse(totalPages: 0, results: []))
    var recievedPage: Int = 0
    func loadMoviesListData(page: Int) -> AnyPublisher<MovieItemListResponse, Error> {
        recievedPage = page
        return Just(result)
            .setFailureType(to: Error.self)
            .flatMap { result -> AnyPublisher<MovieItemListResponse, Error> in
                switch result {
                case .success(let value):
                    return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
                case .failure(let error):
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
        
    func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error> {
        fatalError() // Later
    }
    
    func fetchGenres() -> AnyPublisher<GenresResponse, any Error> {
        let genre = Genre(id: 1, name: "Action")
        let response = GenresResponse(genres: [genre])
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


