import SwiftUI
import SwiftData

struct MoviesListView: View {
    @Environment(Router.self) private var router
    @StateObject private var viewModel: MoviesListViewModel = MoviesListViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var filters: [Genre] {
        switch viewModel.state {
        case .loading, .error, .empty:
            return []
        case let .loaded(presentations, _):
            return presentations.filterList
        }
    }

    var body: some View {
        ZStack {
            VStack {
                FilterView(viewModel: FilterViewModel(filters: filters, selectedFilter: $viewModel.selectedFilter))
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

        case let .loaded(presentations, isLoading):
            ScrollView {
                ZStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(presentations.moviesItemsList, id: \.self) { item in
                            MovieGridItemView(item: item)
                                .onAppear {
                                    let index = presentations.moviesItemsList.lastIndex(of: item)
                                    if let index, index == presentations.moviesItemsList.count - 1 {
                                        print(presentations.moviesItemsList[index], index)
                                        viewModel.loadData()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)

                    if isLoading {
                        LoadingView(isLoading: true)
                    }
                }
            }
        }
    }
}

