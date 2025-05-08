import Foundation
import SwiftData

class ArticleCache {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ movieList: PopularMovieList) {
        // Remove existing PopularMovieList and its related MovieItems
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
