import Foundation
import SwiftData

@Model
class MovieItem: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var releaseDate: String
    var posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }

    init(
        id: Int,
        title: String,
        releaseDate: String,
        posterPath: String
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }

    // MARK: - Codable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let posterPath = try container.decode(String.self, forKey: .posterPath)
        self.init(id: id, title: title, releaseDate: releaseDate, posterPath: posterPath)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(posterPath, forKey: .posterPath)
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(releaseDate)
        hasher.combine(posterPath)
    }

    // MARK: - Equatable
    static func == (lhs: MovieItem, rhs: MovieItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.posterPath == rhs.posterPath
    }
}

