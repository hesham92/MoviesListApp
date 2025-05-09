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
                VStack(alignment: .leading, spacing: 4) {
                    // Poster Image
                    MovieImage(path: movie.posterPath)
                    
                    HStack(alignment: .top) {
                        MovieImage(path: movie.posterPath)
                            .frame(width: 50, height: 100)
                            .padding(.all, 8)
                        
                        VStack(alignment: .leading) {
                            Text("\(movie.title) (\(movie.releaseDate))")
                                .font(.system(size: 16, weight: .bold))
                            
                            if !movie.genres.isEmpty {
                                Text(movie.genres.map { $0.name }.joined(separator: ", "))
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    
                    Text(movie.overview)
                        .font(.system(size: 14))
                    
                    Spacer(minLength: 30)
                    
                    if let homepage = movie.homepage {
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
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("Budget:")
                                    .bold()
                                Text(movie.budget.formatted(.currency(code: "USD")))
                            }
                            
                            HStack {
                                Text("Status:")
                                    .bold()
                                Text(movie.status)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            if let runtime = movie.runtime {
                                HStack {
                                    Text("Runtime:")
                                        .bold()
                                    Text("\(runtime) minutes")
                                }
                            }
                                                        
                            HStack {
                                Text("Revenue:")
                                    .bold()
                                Text(movie.revenue.formatted(.currency(code: "USD")))
                            }
                        }
                    }
                }
                .font(.system(size: 12)) // Custom small font size
                .padding(.all, 8)
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

