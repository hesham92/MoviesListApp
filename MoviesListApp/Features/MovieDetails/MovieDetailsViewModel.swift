import Foundation
import Combine
import SwiftData

@MainActor
class MovieDetailsViewModel: ObservableObject {
    init(movieId: Int) {
        self.repository = MovieDetailsRepository(movieId: movieId)
    }

    func viewDidAppear() {
        bindPublishers()
        loadData()
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        repository.loadMovieDetails()
    }
    
    private func bindPublishers() {
        // Subscribe to the repository's publisher
        repository.$movie
            .dropFirst() // Ignore initial emission
            .receive(on: DispatchQueue.main)
            .sink { [weak self] respone in
                guard let self else { return }
                
                movie = respone
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
    }
    
    @Published var movie: MovieItemDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let repository: MovieDetailsRepository
    private var cancellables = Set<AnyCancellable>()
}

