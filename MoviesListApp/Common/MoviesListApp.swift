import SwiftUI
import SwiftData

@main
struct MoviesListApp: App {
    @State private var context = try! ModelContext(ModelContainer(for: MovieItem.self))
    var body: some Scene {
        WindowGroup {
            MoviesListView(context: context)
                .withRouter()
        }
        .environment(\.modelContext, context)
    }
}
