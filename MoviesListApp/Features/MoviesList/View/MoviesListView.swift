import SwiftUI
import SwiftData

struct MoviesListView: View {
    @Environment(\.modelContext) private var context
    @Environment(Router.self) private var router
    @StateObject private var viewModel: MoviesListViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private let filters = [
        "Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary",
        "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery",
        "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"
    ]

    // Custom initializer to pass ModelContext to the ViewModel
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: MoviesListViewModel(context: context))
    }

    var body: some View {
        ZStack {
            VStack {
                FilterView(filters: filters, selectedFilter: $viewModel.selectedFilter)
                    .padding(.bottom, 10)
                    .frame(height: 40)

                content
                    .onAppear {
                        viewModel.viewDidAppear()
                    }
            }
        }
        .background(Color(UIColor.black))
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView(isLoading: true)

        case .error(let message):
            ErrorView(message: message, retryAction: viewModel.loadData)

        case .empty:
            Text("No movies found.")
                .foregroundColor(.white)
                .padding()

        case .loaded(let presentations):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(presentations.indices, id: \.self) { index in
                        MovieGridItemView(item: presentations[index])
                            .onAppear {
                                if index == presentations.count - 1 {
                                    viewModel.loadData()
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

