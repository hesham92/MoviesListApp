import SwiftData
import Foundation

@Model
class MovieItem: Identifiable, Codable {
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String

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
