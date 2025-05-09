import Foundation
import Combine
import SwiftData

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [MovieItem] = []
    @Published var isConnected: Bool = true
    private var totalPages = 1
    private var currentPage = 0

    private let repository: MoviesRepository
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()

    init(
        context: ModelContext,
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.repository = MoviesRepository(context: context)
        self.networkMonitor = networkMonitor
    }

    func viewDidAppear() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                isConnected = status
                loadData()
            }
            .store(in: &cancellables)
        
        
        // Subscribe to the repository's publisher
        repository.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                
                movies = data
                currentPage += 1
            }
            .store(in: &cancellables)
        
        repository.$totalPages
            .assign(to: \.totalPages, on: self)
            .store(in: &cancellables)
    }

    func loadData() {
        guard currentPage <= totalPages else { return }
        
        repository.loadMoviesListData(page: 1, isOnline: isConnected)
    }
}
