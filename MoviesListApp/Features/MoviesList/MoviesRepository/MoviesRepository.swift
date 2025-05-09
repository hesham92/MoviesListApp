import Foundation
import Combine
import SwiftData
import Network

class MoviesRepository: ObservableObject {
    @Published var movies: [MovieItem] = []
    @Published var totalPages: Int = 10
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init(
        context: ModelContext,
        moviesService: MoviesService = MoviesService()
    ) {
        self.cache = MoviesCache(modelContext: context)
        self.service = moviesService
    }
    
    func loadMoviesListData(page: Int, isOnline: Bool) {
//        guard isOnline else {
//            movies = cache.load()
//            return
//        }
        
        isLoading = true
        errorMessage = nil

        service.fetchArticles(endpoint: ApiEndpoints.moviePopular(page: page))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {[weak self] completion in
                    guard let self else { return }
                    
                    isLoading = false
                    if case .failure(let error) = completion {
                        errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    movies.append(contentsOf: response.results)
                    totalPages = response.totalPages
                  //  cache.save(response.results)

                    downloadImages(results: response.results)
                }
            )
            .store(in: &cancellables)
    }

    private func downloadImages(results: [MovieItem]) {
        for item in results {
            self.downloadImage(for: item) { imageData in
                item.imageData = imageData
            }
        }
    }
    private func downloadImage(for item: MovieItem, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + item.posterPath) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
    
    
    private let service: MoviesService
    private let cache: MoviesCache
    private var cancellables = Set<AnyCancellable>()
}

