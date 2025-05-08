import Foundation
import Combine
import SwiftData
import Network

class ArticleRepository: ObservableObject {
    @Published var articles: [Article] = []

    private let service: ArticleService
    private let cache: ArticleCache
    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private var cancellables = Set<AnyCancellable>()

    private var isOffline = false

    init(context: ModelContext) {
        self.service = ArticleService()
        self.cache = ArticleCache(context: context)
        self.monitor = NWPathMonitor()
        self.startMonitoring()
        loadInitialData()
    }

    private func loadInitialData() {
        // Load cached first
        articles = cache.load()
        // Try to fetch online if available
        if !isOffline {
            fetchFromAPI()
        }
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let wasOffline = self.isOffline
            self.isOffline = path.status != .satisfied

            // If just reconnected
            if wasOffline && !self.isOffline {
                self.fetchFromAPI()
            }
        }
        monitor.start(queue: monitorQueue)
    }

    private func fetchFromAPI() {
        service.fetchArticles()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] fetched in
                      self?.cache.save(fetched)
                      DispatchQueue.main.async {
                          self?.articles = fetched
                      }
                  })
            .store(in: &cancellables)
    }
}
