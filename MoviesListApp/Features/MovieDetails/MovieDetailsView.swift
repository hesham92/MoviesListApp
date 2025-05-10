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
                // Loading Indicator
                ProgressView("Loading...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                // Error State
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
                // Movie Content
                VStack(alignment: .leading, spacing: 8) {

                    // Poster Image (Full Width)
                    if let poster = viewModel.posterPath {
                        MovieImage(path: poster)
                    }

                    // Title & Genres with Poster Thumbnail
                    HStack(alignment: .top) {
                        if let poster = viewModel.posterPath {
                            MovieImage(path: poster)
                                .frame(width: 50, height: 100)
                                .padding(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.formattedTitle)
                                .font(.system(size: 16, weight: .bold))
                            
                            if !viewModel.formattedGenres.isEmpty {
                                Text(viewModel.formattedGenres)
                            }
                        }
                        .padding(.top, 10)
                    }

                    // Overview
                    Text(viewModel.overviewText)
                        .font(.system(size: 14))
                        .padding(.vertical, 8)

                    // Optional Homepage Link
                    if let homepage = viewModel.homepageText {
                        HStack {
                            Text(homepage)
                                .underline()
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 4)
                    }

                    // Optional Languages
                    if let languages = viewModel.languagesText {
                        HStack {
                            Text(languages)
                        }
                        .padding(.vertical, 4)
                    }

                    // Financial and Status Info
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
                    .padding(.top, 8)
                }
                .font(.system(size: 12))
                .padding(8)
            } else {
                // Fallback if no data
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

    // Custom back button overlay
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
