import SwiftData
import SwiftUI

protocol MoviesCache {
    func save(_ items: [MovieItem])
    func load() -> [MovieItem]
}

class MoviesCacheImpl: MoviesCache {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ items: [MovieItem]) {
        for item in items {
            modelContext.insert(item)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error saving items: \(error)")
        }
    }

    func load() -> [MovieItem] {
        let descriptor = FetchDescriptor<MovieItem>(sortBy: [SortDescriptor(\.title)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error loading movies: \(error)")
            return []
        }
    }
}

