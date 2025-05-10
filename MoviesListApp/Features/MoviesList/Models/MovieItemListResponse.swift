import SwiftData
import Foundation

class MovieItemListResponse: Identifiable, Codable, Equatable {
    static func == (lhs: MovieItemListResponse, rhs: MovieItemListResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
    var totalPages: Int
    var results: [MovieItem] = []

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }

    init(totalPages: Int, results: [MovieItem]) {
        self.totalPages = totalPages
        self.results = results
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        let results = try container.decode([MovieItem].self, forKey: .results)
        self.init(totalPages: totalPages, results: results)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(results, forKey: .results)
    }
}
