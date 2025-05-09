import Foundation
import SwiftData

class MoviesCache {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ movieList: PopularMovieList) {
        let descriptor = FetchDescriptor<PopularMovieList>()
        if let existingLists = try? context.fetch(descriptor) {
            for list in existingLists {
                context.delete(list)
            }
        }

        // Insert the new movie list (which includes its movie items)
        context.insert(movieList)

        try? context.save()
    }

    func load() -> PopularMovieList? {
        let descriptor = FetchDescriptor<PopularMovieList>()
        return try? context.fetch(descriptor).first
    }
}
