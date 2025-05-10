//import Foundation
//import Combine
//import SwiftData
//import Network
//
//class MoviesListRepository: ObservableObject {
//    @Published var movies: [MovieItem] = []
//    @Published var totalPages: Int = 10
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    
//    init(
//        context: ModelContext,
//        networkClient: NetworkClient = NetworkClient()
//    ) {
//        self.cache = MoviesCache(modelContext: context)
//        self.networkClient = networkClient
//    }
//    
//    func loadMoviesListData(page: Int, isOnline: Bool) {
//        isLoading = true
//        errorMessage = nil
//
//        networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: {[weak self] completion in
//                    guard let self else { return }
//                    
//                    isLoading = false
//                    if case .failure(let error) = completion {
//                        errorMessage = error.localizedDescription
//                    }
//                },
//                receiveValue: { [weak self] (response: MovieItemListResponse) in
//                    guard let self else { return }
//
//                    movies.append(contentsOf: response.results)
//                    totalPages = response.totalPages
//                  //  cache.save(response.results)
//
//                }
//            )
//            .store(in: &cancellables)
//    }
//    
//    
//    private let networkClient: NetworkClient
//    private let cache: MoviesCache
//    private var cancellables = Set<AnyCancellable>()
//}
//

import Foundation
import Combine
import SwiftData
import Network

class MoviesListRepository: ObservableObject {
    @Published var movies: [MovieItemDetails] = []  // Now an array of MovieItemDetails
    @Published var totalPages: Int = 10
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let networkClient: NetworkClient
    private let cache: MoviesCache
    private var cancellables = Set<AnyCancellable>()
    
    init(
        context: ModelContext,
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.cache = MoviesCache(modelContext: context)
        self.networkClient = networkClient
    }

    // Load the movie list and fetch their details
    func loadMoviesListData(page: Int, isOnline: Bool) {
        isLoading = true
        errorMessage = nil
        
        // Fetch the list of movies (basic data) from the moviesList endpoint
        networkClient.getData(endpoint: ApiEndpoints.moviesList(page: page))
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] (response: MovieItemListResponse) -> AnyPublisher<[MovieItemDetails], Error> in
                guard let self = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                // Fetch movie details for each movie ID in parallel
                let idPublishers = response.results.map { movie in
                    self.fetchMovieDetails(for: movie.id)  // Fetch details using movie IDs
                }
                
                // Use MergeMany to merge the individual publishers and then collect them into an array
                return Publishers.MergeMany(idPublishers)
                    .collect()  // Collect all the MovieItemDetails into an array
                    .map { details in
                        // Update the totalPages here since we have the response at this stage
                        self.totalPages = response.totalPages
                        return details
                    }
                    .eraseToAnyPublisher()  // Ensure the return type is AnyPublisher<[MovieItemDetails], Error>
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] (moviesWithDetails: [MovieItemDetails]) in
                    guard let self = self else { return }
                    self.movies.append(contentsOf: moviesWithDetails)
                }
            )
            .store(in: &cancellables)
    }

    // Fetch movie details for a specific movie ID using the movieDetail endpoint
    private func fetchMovieDetails(for id: Int) -> AnyPublisher<MovieItemDetails, Error> {
        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: id))
            .map { (response: MovieItemDetails) in
                // Return the raw decoded response as MovieItemDetails
                return response
            }
            .eraseToAnyPublisher()
    }
}
