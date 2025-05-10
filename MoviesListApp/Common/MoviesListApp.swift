import SwiftUI
import SwiftData

@main
struct MoviesListApp: App {
    @Environment(\.modelContext) private var context
    var body: some Scene {
        WindowGroup {
            MoviesListView(context: context)
                .withRouter()
        }
        .modelContainer(for: MovieItemDetails.self)
    }
}
