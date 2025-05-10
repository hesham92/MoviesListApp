import SwiftData
import SwiftUI

class MoviesCache {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func clearCache() {
        let descriptor = FetchDescriptor<MovieItemDetails>()
        do {
            let allItems = try modelContext.fetch(descriptor)
            for item in allItems {
                modelContext.delete(item)
            }
            try modelContext.save()
        } catch {
            print("Error clearing cache: \(error)")
        }
    }

    func save(_ items: [MovieItemDetails]) {
        clearCache()  // Clear existing items before saving new ones
        for item in items {
            modelContext.insert(item)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error saving items: \(error)")
        }
    }

    func load() -> [MovieItemDetails] {
        let descriptor = FetchDescriptor<MovieItemDetails>(sortBy: [SortDescriptor(\.title)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error loading movies: \(error)")
            return []
        }
    }
}

