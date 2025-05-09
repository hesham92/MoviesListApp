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
    }

    func configure() {
        startMonitoring()
        loadNextPage()
    }
    
    func loadNextPage() {
        guard canLoadMore && !isOffline else { return }

        service.fetchArticles(endpoint: ApiEndpoints.moviePopular(page: currentPage))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in

                    if case .failure(let error) = completion {
                        print("Error fetching articles:", error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }

                    if response.totalPages <= self.currentPage {
                        self.canLoadMore = false
                    }

                    self.articles.append(contentsOf: response.results)
                    self.currentPage += 1

                    for item in response.results {
                        self.downloadImage(for: item) { [weak self] imageData in
                            guard let self = self else { return }
                            item.imageData = imageData
                            try? self.context.save()
                        }
                    }

                    self.isLoading = false
                }
            )
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

                if self.isOffline {
                    if let cachedList = self.cache.load() {
                        self.articles = cachedList.results
                    }
                } else {
                    self.loadNextPage()
                }
            }
        

        monitor.start(queue: monitorQueue)
    }
}

