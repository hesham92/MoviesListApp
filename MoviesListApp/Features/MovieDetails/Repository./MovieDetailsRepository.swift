import Foundation
import Combine
import SwiftData
import Network

class MovieDetailsRepository: ObservableObject {
    @Published var movie: MovieItemDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init(
        movieId: Int,
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.movieId = movieId
        self.networkClient = networkClient
    }
    
    func loadMovieDetails() {
//        guard isOnline else {
//            movies = cache.load()
//            return
//        }
        
        isLoading = true
        errorMessage = nil

        networkClient.getData(endpoint: ApiEndpoints.movieDetail(id: movieId))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {[weak self] completion in
                    guard let self else { return }
                    
                    isLoading = false
                    if case .failure(let error) = completion {
                        errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] (response: MovieItemDetails) in
                    guard let self  else { return }
                    
                    movie = response
                }
            )
            .store(in: &cancellables)
    }
    
    private let movieId: Int
    private let networkClient: NetworkClient
    private var cancellables = Set<AnyCancellable>()
}

