import SwiftData
import Foundation

@Model
class MovieItem: Identifiable, Codable {
    var id: Int

    enum CodingKeys: String, CodingKey {
        case id
    }

    init(id: Int) {
        self.id = id
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        self.init(id: id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}
