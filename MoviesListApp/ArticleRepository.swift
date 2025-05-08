import Foundation
import Combine
import SwiftData
import Network

class ArticleRepository: ObservableObject {
    @Published var articles: [MovieItem] = []

    private let service: ArticleService
    private let cache: ArticleCache
    private let context: ModelContext
    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    private var cancellables = Set<AnyCancellable>()
    
    private var isOffline = false
    private var currentPage = 1
    private var isLoading = false
    private var canLoadMore = true

    init(context: ModelContext) {
        self.service = ArticleService()
        self.cache = ArticleCache(context: context)
        self.context = context
        self.monitor = NWPathMonitor()
        self.startMonitoring()

        loadNextPage()
    }

    func loadNextPage() {
        guard !isLoading, canLoadMore else { return }
        isLoading = true

        let endpoint = ApiEndpoints.moviePopular(page: currentPage)

        service.fetchArticles(endpoint: endpoint)
            .map(\.results)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                guard let self = self else { return }

                if newItems.isEmpty {
                    self.canLoadMore = false
                } else {
                    self.articles.append(contentsOf: newItems)
                    self.currentPage += 1

                    for item in newItems {
                        self.downloadImage(for: item) { [weak self] imageData in
                            guard let self = self else { return }
                            DispatchQueue.main.async {
                                item.imageData = imageData
                                try? self.context.save()
                            }
                        }
                    }
                }

                self.isLoading = false
            }
            .store(in: &cancellables)
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
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isOffline = path.status != .satisfied

            if !self.isOffline {
                self.loadNextPage()
            } else {
                // Load cached list if available
                if let cachedList = cache.load() {
                    self.articles = cachedList.results
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }
}
