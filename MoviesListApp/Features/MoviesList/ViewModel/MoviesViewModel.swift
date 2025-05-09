import Foundation
import Combine
import SwiftData

@MainActor
class MoviesListViewModel: ObservableObject {
    init(
        context: ModelContext,
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.repository = MoviesRepository(context: context)
        self.networkMonitor = networkMonitor
    }

    func viewDidAppear() {
        bindPublishers()
    }
    
    func loadData() {
        guard currentPage <= totalPages else { return }
        
        repository.loadMoviesListData(page: currentPage, isOnline: isConnected)
    }
    
    private func bindPublishers() {
        networkMonitor.$isConnected
            .dropFirst() // Ignore initial emission
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                isConnected = status
                loadData()
            }
            .store(in: &cancellables)
        
        
        // Subscribe to the repository's publisher
        repository.$movies
            .dropFirst() // Ignore initial emission
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                
                movies = data
                currentPage += 1
            }
            .store(in: &cancellables)
        
        repository.$totalPages
            .dropFirst() // Ignore initial emission
            .assign(to: \.totalPages, on: self)
            .store(in: &cancellables)
    }
    
    @Published var movies: [MovieItem] = []
    @Published var isConnected: Bool = true
    private var totalPages = 10
    private var currentPage = 1

    private let repository: MoviesRepository
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
}
