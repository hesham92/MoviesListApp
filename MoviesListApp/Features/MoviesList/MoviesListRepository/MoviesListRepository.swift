import Foundation
import Combine
import SwiftData
import Network
import Factory

protocol MoviesListRepository {
    func loadMoviesListData(page: Int) -> AnyPublisher<MovieItemListResponse, Error>
    func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error>
}

class MoviesListRepositoryImpl: MoviesListRepository {
    func loadMoviesListData(page: Int) -> AnyPublisher<MovieItemListResponse, Error> {
        Just(cache.load()).map {
            MovieItemListResponse(totalPages: 100, results: $0)
        }
        .setFailureType(to: Error.self)
        .merge(with: networkMonitor.isConnectedPublisher.eraseToAnyPublisher().removeDuplicates().flatMap { [weak self] isConnected in
            guard let self, isConnected else { return Empty<MovieItemListResponse, Error>().eraseToAnyPublisher() }
            
            return networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
                .map{ [weak self] (response: MovieItemListResponse) in
                    self?.cache.save(response.results)
                    return response
                }
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
    }

    func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error> {
        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: id))
    }
    
    @Injected(\.networkClient) private var networkClient
    @Injected(\.networkMonitor) private var networkMonitor
    @Injected(\.moviesCache) private var cache
}
