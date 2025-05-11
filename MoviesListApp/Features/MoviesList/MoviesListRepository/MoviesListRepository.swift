import Foundation
import Combine
import SwiftData
import Network
import Factory

protocol MoviesListRepository {
    func loadMoviesListData(page: Int) -> AnyPublisher<MovieItemListResponse, Error>
    func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error>
    func fetchGenres() -> AnyPublisher<GenresResponse, Error>
}

class MoviesListRepositoryImpl: MoviesListRepository {
    @Injected(\.networkClient) private var networkClient
    @Injected(\.networkMonitor) private var networkMonitor
    @Injected(\.moviesCache) private var cache
    
    func loadMoviesListData(page: Int) -> AnyPublisher<MovieItemListResponse, Error> {
        networkMonitor
            .isConnectedPublisher
            .eraseToAnyPublisher()
            .removeDuplicates()
            .flatMap { [weak self] isConnected in
                guard let self else { return Empty<MovieItemListResponse, Error>().eraseToAnyPublisher() }
                guard isConnected else {
                    return Just(cache.load())
                        .setFailureType(to: Error.self)
                        .map { MovieItemListResponse(results: $0) }
                        .eraseToAnyPublisher()
                }
                
                return networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
                    .map{ [weak self] (response: MovieItemListResponse) in
                        self?.cache.save(response.results)
                        return response
                    }
                    .eraseToAnyPublisher()
            }
        
            .eraseToAnyPublisher()
    }

    func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error> {
        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: id))
    }
    
    func fetchGenres() -> AnyPublisher<GenresResponse, Error> {
        networkClient.getData(endpoint: ApiEndpoints.moviesGenres)
    }
}
