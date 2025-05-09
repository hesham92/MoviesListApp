import Foundation
import Combine
import SwiftData

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [MovieItem] = []
    @Published var isConnected: Bool = true

    private let repository: MoviesRepository
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()

    init(repository: MoviesRepository, networkMonitor: NetworkMonitor = NetworkMonitor()) {
        self.repository = repository
        self.networkMonitor = networkMonitor
    }

    func viewDidAppear() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isConnected = status
                self?.loadNextPage()
            }
            .store(in: &cancellables)
        
        
        // Subscribe to the repository's publisher
        repository.$movies
            .receive(on: DispatchQueue.main)
            .assign(to: &$movies)
    }

    func loadNextPage() {
        repository.loadNextPage()
    }
}

