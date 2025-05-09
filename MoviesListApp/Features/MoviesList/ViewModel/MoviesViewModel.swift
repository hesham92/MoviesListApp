import Foundation
import Combine
import SwiftData

@MainActor
class MoviesListViewModel: ObservableObject {
    init(
        context: ModelContext,
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.repository = MoviesListRepository(context: context)
        self.networkMonitor = networkMonitor
    }

    func viewDidAppear() {
        bindPublishers()
    }
    
    func loadData() {
        guard currentPage <= totalPages else { return }
        
        isLoading = true
        errorMessage = nil
        
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
        
        repository.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        repository.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        
        repository.$totalPages
            .dropFirst() // Ignore initial emission
            .assign(to: \.totalPages, on: self)
            .store(in: &cancellables)
    }
    
    // This function is called whenever the filter changes to apply the selected filter
//    private func filterMovies() {
//        // Filter the movies based on the selected filter
//        if selectedFilter == "All" {
//            filteredMovies = movies  // Show all movies
//        } else {
//            filteredMovies = movies.filter { movie in
//                movie.genre == selectedFilter
//            }
//        }
//    }
    
    @Published var selectedFilter: String = "All" {
        didSet {
            // Apply filter when the selected filter changes
           // filterMovies()
        }
    }
    
    var filteredMovies: [MovieItem] = []
    @Published var movies: [MovieItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published private var isConnected: Bool = true
    private var totalPages = 10
    private var currentPage = 1

    private let repository: MoviesListRepository
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
}
