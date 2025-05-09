import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel

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
            } else if let movie = viewModel.movie {
                VStack(alignment: .leading, spacing: 16) {
                    // Poster Image
                    if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                        AsyncImage(url: posterURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    Group {
                        HStack {
                            Text("Release Date:")
                                .bold()
                            Text(movie.releaseDate)
                        }

                        if !movie.genres.isEmpty {
                            HStack {
                                Text("Genres:")
                                    .bold()
                                Text(movie.genres.map { $0.name }.joined(separator: ", "))
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Overview:")
                                .bold()
                            Text(movie.overview)
                        }

                        if let homepage = movie.homepage, let url = URL(string: homepage) {
                            Link("Homepage", destination: url)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }

                        HStack {
                            Text("Budget:")
                                .bold()
                            Text(movie.budget.formatted(.currency(code: "USD")))
                        }

                        HStack {
                            Text("Revenue:")
                                .bold()
                            Text(movie.revenue.formatted(.currency(code: "USD")))
                        }

                        if !movie.spokenLanguages.isEmpty {
                            HStack {
                                Text("Languages:")
                                    .bold()
                                Text(movie.spokenLanguages.map { $0.name }.joined(separator: ", "))
                            }
                        }

                        HStack {
                            Text("Status:")
                                .bold()
                            Text(movie.status)
                        }

                        if let runtime = movie.runtime {
                            HStack {
                                Text("Runtime:")
                                    .bold()
                                Text("\(runtime) minutes")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            } else {
                Text("No movie data available.")
                    .padding()
            }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
}

