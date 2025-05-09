import SwiftUI
import SwiftData

struct MoviesListContent: View {
    @ObservedObject private var viewModel: MoviesListViewModel
    @Environment(Router.self) var router
    @Binding var selectedMovieId: Int?
    @State private var showAlert = false

    init(modelContext: ModelContext, selectedMovieId: Binding<Int?>) {
        _viewModel = ObservedObject(wrappedValue: MoviesListViewModel(context: modelContext))
        self._selectedMovieId = selectedMovieId
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let filters = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]

    var body: some View {
        ZStack {
            VStack {
                FilterView(filters: filters, selectedFilter: $viewModel.selectedFilter)
                    .padding(.bottom, 10)
                    .frame(height: 40)

                MovieGridView(viewModel: viewModel, selectedMovieId: $selectedMovieId)
                    .onAppear {
                        viewModel.viewDidAppear()
                    }
            }

            LoadingView(isLoading: viewModel.isLoading)
        }
        .background(Color(UIColor.black))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                }
            )
        }
        .onChange(of: viewModel.errorMessage) { error in
            showAlert = error != nil
        }
    }
}
