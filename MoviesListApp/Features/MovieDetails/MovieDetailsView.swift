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
        case .loaded:
            MovieContentView(viewModel: viewModel)  // Pass the entire viewModel here
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



extension Font {
    static let movieTitle = Font.system(size: 16, weight: .bold)
    static let movieBody = Font.system(size: 14)
}

extension Color {
    static let movieBackground = Color.black
    static let movieText = Color.white
    static let movieAccent = Color.blue
}



struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Error: \(message)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.movieAccent)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}



struct MovieStatsView: View {
    let budget: String
    let status: String
    let runtime: String
    let revenue: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(budget)
                Text(status)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text(runtime)
                Text(revenue)
            }
        }
        .padding(.top, 8)
    }
}


struct MovieHeaderView: View {
    let posterPath: String?
    let title: String
    let genres: String

    var body: some View {
        HStack(alignment: .top) {
            if let poster = posterPath {
                MovieImage(path: poster)
                    .frame(width: 50, height: 100)
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.movieTitle)

                if !genres.isEmpty {
                    Text(genres)
                }
            }
            .padding(.top, 10)
        }
    }
}


struct MovieContentView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let poster = viewModel.posterPath {
                MovieImage(path: poster)
            }

            MovieHeaderView(
                posterPath: viewModel.posterPath,
                title: viewModel.formattedTitle,
                genres: viewModel.formattedGenres
            )

            Text(viewModel.overviewText)
                .font(.movieBody)
                .padding(.vertical, 8)

            if let homepage = viewModel.homepageText {
                Text(homepage)
                    .underline()
                    .foregroundColor(.movieAccent)
                    .padding(.vertical, 4)
            }

            if let languages = viewModel.languagesText {
                Text(languages)
                    .padding(.vertical, 4)
            }

            MovieStatsView(
                budget: viewModel.budgetText,
                status: viewModel.statusText,
                runtime: viewModel.runtimeText,
                revenue: viewModel.revenueText
            )
        }
        .font(.movieBody)
        .padding(8)
    }
}
