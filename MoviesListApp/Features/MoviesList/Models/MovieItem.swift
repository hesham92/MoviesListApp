import Foundation
import SwiftData

@Model
class MovieItem: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var releaseDate: String
    var posterPath: String
    var genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
    }

    init(
        id: Int,
        title: String,
        releaseDate: String,
        posterPath: String,
        genreIds: [Int]
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.genreIds = genreIds
    }

    // MARK: - Codable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let posterPath = try container.decode(String.self, forKey: .posterPath)
        let genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.init(id: id, title: title, releaseDate: releaseDate, posterPath: posterPath, genreIds: genreIds)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(genreIds, forKey: .genreIds)
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(releaseDate)
        hasher.combine(posterPath)
        hasher.combine(genreIds)
    }

    // MARK: - Equatable
    static func == (lhs: MovieItem, rhs: MovieItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.releaseDate == rhs.releaseDate &&
        lhs.posterPath == rhs.posterPath &&
        lhs.genreIds == rhs.genreIds
    }
}

