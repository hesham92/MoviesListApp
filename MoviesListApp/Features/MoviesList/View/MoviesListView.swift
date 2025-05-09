import SwiftUI
import SwiftData

struct MoviesListView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedMovieId: Int?
    
    var body: some View {
        MoviesListContent(modelContext: context, selectedMovieId: $selectedMovieId)
    }
}
