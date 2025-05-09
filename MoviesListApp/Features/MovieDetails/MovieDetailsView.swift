import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel
    @Environment(Router.self) var router

    init(movieId: Int) {
        _viewModel = ObservedObject(wrappedValue: MovieDetailsViewModel(movieId: movieId))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        viewModel.loadData()
                    }
                }
                .padding()
            } else if let _ = viewModel.movie {
                VStack(alignment: .leading, spacing: 4) {
                    // Poster Image
                    if let poster = viewModel.posterPath {
                        MovieImage(path: poster)
                    }

                    HStack(alignment: .top) {
                        if let poster = viewModel.posterPath {
                            MovieImage(path: poster)
                                .frame(width: 50, height: 100)
                                .padding(.all, 8)
                        }

                        VStack(alignment: .leading) {
                            Text(viewModel.formattedTitle)
                                .font(.system(size: 16, weight: .bold))

                            if !viewModel.formattedGenres.isEmpty {
                                Text(viewModel.formattedGenres)
                            }
                        }
                        .padding(.top, 10)
                    }

                    Text(viewModel.overviewText)
                        .font(.system(size: 14))

                    Spacer(minLength: 30)

                    if let homepage = viewModel.homepageText {
                        HStack {
                            Text(homepage)
                                .underline()
                                .foregroundColor(.blue)
                        }
                    }

                    if let languages = viewModel.languagesText {
                        HStack {
                            Text(languages)
                        }
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.budgetText)
                            Text(viewModel.statusText)
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.runtimeText)
                            Text(viewModel.revenueText)
                        }
                    }
                }
                .font(.system(size: 12))
                .padding(.all, 8)
            } else {
                Text("No movie data available.")
                    .padding()
            }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
        .navigationBarHidden(true)
        .background(Color.black)
        .foregroundColor(.white)
        .overlay(customBackButton, alignment: .topLeading)
    }

    private var customBackButton: some View {
        Button(action: {
            router.popToRoot()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}

