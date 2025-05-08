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
        guard !isLoading && canLoadMore else { return }
        isLoading = true

        service.fetchArticles(endpoint: ApiEndpoints.moviePopular(page: currentPage))
            .handleEvents(receiveOutput: { [weak self] fetched in
                guard let self = self else { return }

                for item in fetched.results {
                    self.downloadImage(for: item) { imageData in
                        DispatchQueue.main.async {
                            item.imageData = imageData
                            try? self.context.save()
                        }
                       
                    }
                }
            })
            .map { $0.results }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                guard let self = self else { return }

                if newItems.isEmpty {
                    self.canLoadMore = true
                } else {
                    self.articles.append(contentsOf: newItems)
                    self.currentPage += 1
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



//class ArticleRepository: ObservableObject {
//    @Published var articles: [MovieItem] = []
//
//    private let service: ArticleService
//    private let cache: ArticleCache
//    private let monitor: NWPathMonitor
//    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
//    private var cancellables = Set<AnyCancellable>()
//    private let context: ModelContext
//
//    private var isOffline = false
//
//    init(context: ModelContext) {
//        self.service = ArticleService()
//        self.cache = ArticleCache(context: context)
//        self.monitor = NWPathMonitor()
//        self.context = context
//        self.startMonitoring()
//        self.loadInitialData()
//    }
//

//

//
//    func fetchFromAPI(page: Int) {
//        service.fetchArticles(endpoint: ApiEndpoints.moviePopular(page: page))
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: { [weak self] fetched in
//                      guard let self = self else { return }
//                          self.articles = fetched.results // Show immediately
//                          self.cache.save(fetched)       // Cache without images
//                      
//
//                      // Download images in background
//                      for item in fetched.results {
//                          self.downloadImage(for: item) { imageData in
//                                  item.imageData = imageData
//                                  try? self.context.save()
//                                  
//                                  // Trigger UI update
//                                  if let index = self.articles.firstIndex(where: { $0.id == item.id }) {
//                                      self.articles[index] = item
//                                  }
//                          }
//                      }
//                  })
//            .store(in: &cancellables)
//    }
//    
//   
//    
//    
//    
//    
//    private func downloadImage(for item: MovieItem, completion: @escaping (Data?) -> Void) {
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + item.posterPath) else {
//            completion(nil)
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            completion(data)
//        }.resume()
//    }
//}
