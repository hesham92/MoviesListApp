import SwiftUI

struct MovieDetailsHeaderViewPresentation {
    init(movieItem: MovieItemDetails) {
        self.movieItem = movieItem
    }
    
    var posterPath: String {
        movieItem.posterPath
    }
    var formattedGenres: String {
        return movieItem.genres.map { $0.name }.joined(separator: ", ")
    }
    
    var formattedTitle: String {
        return "\(movieItem.title) (\(movieItem.releaseDate))"
    }
    
    private let movieItem: MovieItemDetails
}

extension MovieDetailsHeaderViewPresentation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieItem.id)
    }
}

struct MovieHeaderView: View {
    let viewModel: MovieDetailsHeaderViewPresentation
    
    var body: some View {
        HStack(alignment: .top) {
            MovieImage(path: viewModel.posterPath)
                .frame(width: 50, height: 100)
                .padding(8)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.formattedTitle)
                    .font(.movieTitle)
                
                Text(viewModel.formattedGenres)
            }
        }
        .padding(.top, 10)
    }
}
