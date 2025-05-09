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
                        .foregroundColor(.red)  // Error message in red
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        viewModel.loadData()
                    }
                }
                .padding()
            } else if let movie = viewModel.movie {
                VStack(alignment: .leading, spacing: 16) {
                    // Poster Image
                    
                   // MovieImage(path: movie.posterPath)
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
                    
                    VStack(alignment: .leading) {
                        Text("\(movie.title) (\(movie.releaseDate))")
                            .font(.system(size: 16, weight: .bold))
                        
                        if !movie.genres.isEmpty {
                            Text(movie.genres.map { $0.name }.joined(separator: ", "))
                        }
                    }
                    
                    Text(movie.overview)
                        .font(.system(size: 14)) // Custom small font size
                    
                    
                    Spacer()

                    if let homepage = movie.homepage, let url = URL(string: homepage) {
                        HStack {
                                    Text("Homepage:")
                                        .bold()
                                        .foregroundColor(.white)
                                    Text(homepage)
                                        .underline()
                                        .foregroundColor(.blue)
                                }
                    }
                    
                    if !movie.spokenLanguages.isEmpty {
                        HStack {
                            Text("Languages:")
                                .bold()
                            Text(movie.spokenLanguages.map { $0.name }.joined(separator: ", "))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            HStack {
                                Text("Status:")
                                    .bold()
                                Text(movie.status)
                            }
                            
                            Spacer()

                            if let runtime = movie.runtime {
                                HStack {
                                    Text("Runtime:")
                                        .bold()
                                    Text("\(runtime) minutes")
                                }
                            }
                        }
                        HStack {
                            HStack {
                                Text("Budget:")
                                    .bold()
                                Text(movie.budget.formatted(.currency(code: "USD")))
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text("Revenue:")
                                    .bold()
                                Text(movie.revenue.formatted(.currency(code: "USD")))
                            }
                        }
                    }
                   
                    
                    }
                .font(.system(size: 12)) // Custom small font size
                    .padding(.horizontal)
            } else {
                Text("No movie data available.")
                    .padding()
            }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
        .navigationBarHidden(true)  // Hides the default navigation bar
        .background(Color.black)  // Set background to black
        .foregroundColor(.white)  // Set all text to white
        .overlay(
            customBackButton, alignment: .topLeading  // Add custom back button on top left
        )
    }

    private var customBackButton: some View {
        Button(action: {
            router.popToRoot()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)  // White color
                .font(.system(size: 20))  // Smaller size
                .padding()
        }
        .padding(.top, 16)  // Padding from the top to avoid it being too close to the edge
        .padding(.leading, 16)  // Padding from the left
    }
}

