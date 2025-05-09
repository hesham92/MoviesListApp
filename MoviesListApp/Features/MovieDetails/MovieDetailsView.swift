import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel

    init(movieId: Int) {
        _viewModel = ObservedObject(wrappedValue: MovieDetailsViewModel(movieId: movieId))
    }

    var body: some View {
        ScrollView {
            if let movie = viewModel.movie {
                VStack(alignment: .leading, spacing: 16) {

                    // Poster Image
                    if let posterURL = URL(string: movie.posterPath) {
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
                        // Release Date
                        HStack {
                            Text("Release Date:")
                                .bold()
                            Text(movie.releaseDate)
                        }

                        // Genres
                        if !movie.genres.isEmpty {
                            HStack {
                                Text("Genres:")
                                    .bold()
                                Text(movie.genres.map { $0.name }.joined(separator: ", "))
                            }
                        }

                        // Overview
                        VStack(alignment: .leading) {
                            Text("Overview:")
                                .bold()
                            Text(movie.overview)
                        }

                        // Homepage
                        if let homepage = movie.homepage, let url = URL(string: homepage) {
                            Link("Homepage", destination: url)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }

                        // Budget
                        HStack {
                            Text("Budget:")
                                .bold()
                            Text(movie.budget.formatted(.currency(code: "USD")))
                        }

                        // Revenue
                        HStack {
                            Text("Revenue:")
                                .bold()
                            Text(movie.revenue.formatted(.currency(code: "USD")))
                        }

                        // Spoken Languages
                        if !movie.spokenLanguages.isEmpty {
                            HStack {
                                Text("Languages:")
                                    .bold()
                                Text(movie.spokenLanguages.map { $0.name }.joined(separator: ", "))
                            }
                        }

                        // Status
                        HStack {
                            Text("Status:")
                                .bold()
                            Text(movie.status)
                        }

                        // Runtime
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
                .navigationTitle(movie.title)
            } else {
                ProgressView("Loading...")
                    .padding()
            }
        }
    }
}

