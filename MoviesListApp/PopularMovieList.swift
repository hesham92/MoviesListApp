import SwiftData
import Foundation

@Model
class PopularMovieList: Identifiable, Codable {
    var id: UUID = UUID()
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [MovieItem] = []

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }

    init(page: Int, totalResults: Int, totalPages: Int, results: [MovieItem]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let page = try container.decode(Int.self, forKey: .page)
        let totalResults = try container.decode(Int.self, forKey: .totalResults)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        let results = try container.decode([MovieItem].self, forKey: .results)
        self.init(page: page, totalResults: totalResults, totalPages: totalPages, results: results)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(totalResults, forKey: .totalResults)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(results, forKey: .results)
    }
}

@Model
class MovieItem: Identifiable, Codable {
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String
    var imageData: Data? = nil // Add this

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }

    init(id: Int, title: String, posterPath: String, releaseDate: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let posterPath = try container.decode(String.self, forKey: .posterPath)
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.init(id: id, title: title, posterPath: posterPath, releaseDate: releaseDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(releaseDate, forKey: .releaseDate)
    }
}
