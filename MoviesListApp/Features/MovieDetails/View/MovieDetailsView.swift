import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel
    @Environment(Router.self) var router
    
    init(movieId: Int) {
        _viewModel = ObservedObject(wrappedValue: MovieDetailsViewModel(movieId: movieId))
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
            ForEach(sections, id: \.self) { section in
                switch section {
                case .poster(let path):
                    MovieImage(path: path)
                    
                case .header(let movieDetailsHeaderViewPresentation):
                    MovieHeaderView(viewModel: movieDetailsHeaderViewPresentation)
                    
                case .content(let movieDetailsContentViewPresentation):
                    MovieContentView(viewModel: movieDetailsContentViewPresentation)
                }
            }
            
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
