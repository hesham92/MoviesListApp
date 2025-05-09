import SwiftUI
import SwiftData

struct MovieGridView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    @Binding var selectedMovieId: Int?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let item = viewModel.movies[index]
                    MovieGridItemView(item: item, selectedMovieId: $selectedMovieId)
                        .onAppear {
                            if index == viewModel.movies.count - 1 {
                                viewModel.loadData()
                            }
                        }
                }
            }
        }
    }
}
