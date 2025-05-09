import SwiftData
import SwiftUI

class MoviesCache {
    @Query
    private var movieList: [MovieItem]
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ items: [MovieItem]) {
        // Insert the entire array of MovieItems into the model context
        for item in items {
            modelContext.insert(item)  // Insert each MovieItem into the context
        }
        
        // Optionally, commit the changes to the persistent store
        do {
            try modelContext.save()  // Ensure the changes are saved
        } catch {
            print("Error saving items: \(error)")
        }
    }

    func load() -> [MovieItem] {
        return movieList
    }
}
