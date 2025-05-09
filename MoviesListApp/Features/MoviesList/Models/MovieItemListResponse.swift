import SwiftData
import Foundation

class MovieItemListResponse: Identifiable, Codable {
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
