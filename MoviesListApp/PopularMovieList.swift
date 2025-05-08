import SwiftData
import Foundation

@Model
class PopularMovieList: Identifiable, Codable {
    var id: UUID = UUID()
    var page: Int
    var totalResults: Int
    var totalPages: Int

    @Relationship(deleteRule: .cascade)
    var results: [MovieItem] = []

    enum CodingKeys: String, CodingKey {
        case page, totalResults, totalPages, results
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
    @Attribute(.unique) var id: Int
    var title: String

    enum CodingKeys: String, CodingKey {
        case id, title
    }

    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        self.init(id: id, title: title)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
    }
}
