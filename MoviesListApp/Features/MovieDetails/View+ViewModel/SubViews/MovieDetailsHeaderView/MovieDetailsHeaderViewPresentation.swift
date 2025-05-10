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
