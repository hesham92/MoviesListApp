import Foundation
import Combine
import SwiftData

@MainActor
class ArticleViewModel: ObservableObject {
    @Published var movies: [MovieItem] = []

    private let repository: ArticleRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: ArticleRepository) {
        self.repository = repository

        repository.$movies
            .receive(on: DispatchQueue.main)
            .assign(to: &$movies)
    }
    
    func configure() {
        // Configure the repository and load the first page of articles
        repository.configure() // Now this triggers the loading logic
    }
    
    func loadNextPage() {
        repository.loadNextPage()
    }
}

