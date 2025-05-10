import Foundation
import Combine
import SwiftData
import Network

class MoviesListRepository: ObservableObject {
    private let networkClient: NetworkClient
    private let cache: MoviesCache
    
    init(
        context: ModelContext,
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.cache = MoviesCache(modelContext: context)
        self.networkClient = networkClient
    }
    
    func loadMoviesListData(page: Int) -> some Publisher<MovieItemListResponse, Error> {
        networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
//            .map{ [weak self] response in
//                self?.cache.save(response.results)
//                return response
//            }
    }

    func fetchMovieDetails(for id: Int) -> some Publisher<MovieItemDetails, Error> {
        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: id))
    }
}
