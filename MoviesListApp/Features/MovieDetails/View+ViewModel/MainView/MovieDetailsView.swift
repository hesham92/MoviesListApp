import SwiftUI
import SwiftData

struct MovieDetailsView: View {
    @Environment(Router.self) var router
    @StateObject private var viewModel: MovieDetailsViewModel
    
    init(movieItemId: Int, context: ModelContext) {
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(movieItemId: movieItemId, context: context))
    }

    var body: some View {
        ScrollView {
            content
        }
        .onAppear { viewModel.loadData() }
        .navigationBarHidden(true)
        .background(Color.movieBackground)
        .foregroundColor(.movieText)
        .overlay(customBackButton, alignment: .topLeading)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView(isLoading: true)

        case .error(let msg):
            ErrorView(message: msg, retryAction: viewModel.loadData)
            
        case .loaded(let sections):
            VStack(alignment: .leading) {
                ForEach(sections, id: \.self) { section in
                    switch section {                        
                    case .header(let movieDetailsHeaderViewPresentation):
                        MovieDetailsHeaderView(viewModel: movieDetailsHeaderViewPresentation)
                        
                    case .content(let movieDetailsContentViewPresentation):
                        MovieDetailsContentView(viewModel: movieDetailsContentViewPresentation)
                    }
                }
            }
            .padding(4)
            
        case .empty:
            Text("No movie data available.")
                .padding()
        }
    }
    
    private var customBackButton: some View {
        Button(action: {
            router.popToRoot()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.movieText)
                .font(.system(size: 20))
                .padding()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}
