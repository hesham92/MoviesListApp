import Foundation

struct MovieItemViewPresentation: Hashable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    
    init(movieItem: MovieItem) {
        self.movieItem = movieItem
        self.id = movieItem.id
        self.title = movieItem.title
        self.releaseDate = movieItem.releaseDate
        self.posterPath = movieItem.posterPath
    }
    
    let movieItem: MovieItem
}
