import SwiftUI
import SwiftData

@main
struct MoviesListApp: App {
    var body: some Scene {
        WindowGroup {
            MoviesListView()
                .withRouter()
        }
        .modelContainer(for: MovieItemDetails.self)
    }
}
