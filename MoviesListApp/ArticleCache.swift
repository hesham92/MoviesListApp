import Foundation
import SwiftData

class ArticleCache {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ articles: [Article]) {
        // Remove existing data
        let descriptor = FetchDescriptor<Article>()
        if let existing = try? context.fetch(descriptor) {
            for article in existing {
                context.delete(article)
            }
        }

        for article in articles {
            context.insert(article)
        }

        try? context.save()
    }

    func load() -> [Article] {
        let descriptor = FetchDescriptor<Article>()
        return (try? context.fetch(descriptor)) ?? []
    }
}
