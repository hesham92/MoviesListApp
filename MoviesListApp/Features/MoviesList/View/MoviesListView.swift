import SwiftUI
import SwiftData

struct MoviesListView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        MoviesListContent(modelContext: context)
    }
}
