import Foundation
import Combine
import SwiftData

@MainActor
class ArticleViewModel: ObservableObject {
    @Published var articles: [MovieItem] = []

    private let repository: ArticleRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: ArticleRepository) {
        self.repository = repository

        repository.$articles
            .receive(on: DispatchQueue.main)
            .assign(to: &$articles)
    }
    
    func configure() {
        // Configure the repository and load the first page of articles
        repository.configure() // Now this triggers the loading logic
    }
    
    func loadNextPage() {
        repository.loadNextPage()
    }
}

