import SwiftUI

struct MoviesListView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        MoviesListContent(repository: MoviesRepository(context: modelContext))
    }
}


import SwiftUI

struct MoviesListContent: View {
    @StateObject private var viewModel: MoviesViewModel
    
    init(repository: MoviesRepository) {
        _viewModel = StateObject(wrappedValue: MoviesViewModel(repository: repository))
    }
    
    // Fixed-size columns
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let item = viewModel.movies[index]
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + item.posterPath)) { asyncImagePhase in
                            ZStack {
                                // Always show gray background as placeholder
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 140)
                                    .cornerRadius(8)
                                
                                if let data = item.imageData,
                                   let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 140)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                                
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(item.releaseDate)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .onAppear {
                        if index == viewModel.movies.count - 1 {
                            viewModel.loadNextPage()
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.black))
        .onAppear {
            viewModel.viewDidAppear() // Trigger the loading of the first page when the view appears
        }
    }
}
