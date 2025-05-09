import Foundation
import Combine
import SwiftData
import Network

class MoviesRepository: ObservableObject {
    @Published var movies: [MovieItem] = []
    
    init(
        context: ModelContext,
        moviesService: MoviesService = MoviesService()
    ) {
        self.cache = MoviesCache(context: context)
        self.service = moviesService
        self.context = context
    }
    
    func loadNextPage() {
        guard canLoadMore else { return }

        service.fetchArticles(endpoint: ApiEndpoints.moviePopular(page: currentPage))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching articles:", error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    if response.totalPages <= self.currentPage {
                        self.canLoadMore = false
                    }

                    self.movies.append(contentsOf: response.results)
                    try? self.context.save()
                    self.currentPage += 1

                    downloadImages(results: response.results)
                }
            )
            .store(in: &cancellables)
    }

    private func downloadImages(results: [MovieItem]) {
        for item in results {
            self.downloadImage(for: item) { [weak self] imageData in
                guard let self = self else { return }
                item.imageData = imageData
                try? self.context.save()
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
    
    private var currentPage = 1
    private var isLoading = false
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    
    private let service: MoviesService
    private let cache: MoviesCache
    private let context: ModelContext
}

