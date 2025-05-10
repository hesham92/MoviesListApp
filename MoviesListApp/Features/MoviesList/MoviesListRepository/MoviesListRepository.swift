import Foundation
import Combine
import SwiftData
import Network

class MoviesListRepository: ObservableObject {
    private let networkClient: NetworkClient
    private let networkMonitor: NetworkMonitor
    private let cache: MoviesCache
    
    init(
        context: ModelContext,
        networkClient: NetworkClient = NetworkClient(),
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.cache = MoviesCache(modelContext: context)
        self.networkClient = networkClient
        self.networkMonitor = networkMonitor
    }
    
    func loadMoviesListData(page: Int) -> some Publisher<MovieItemListResponse, Error> {
        Just(cache.load()).map {
            MovieItemListResponse(page: page, totalResults: 0, totalPages: 100, results: $0)
        }
        .setFailureType(to: Error.self)
        .merge(with: networkMonitor.$isConnected.removeDuplicates().flatMap { [weak self] isConnected in
            guard let self, isConnected else { return Empty<MovieItemListResponse, Error>().eraseToAnyPublisher() }
            
            return networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
                .map{ [weak self] (response: MovieItemListResponse) in
                    self?.cache.save(response.results)
                    return response
                }.eraseToAnyPublisher()
        })
    }

    func fetchMovieDetails(for id: Int) -> some Publisher<MovieItemDetails, Error> {
        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: id))
    }
}
