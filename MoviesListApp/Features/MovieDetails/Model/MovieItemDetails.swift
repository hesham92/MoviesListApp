import Foundation
import SwiftData

@Model
class MovieItemDetails: Identifiable, Decodable, Hashable {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var posterPath: String
    var homepage: String
    var budget: Int
    var revenue: Int
    var runtime: Int
    var status: String
    var genres: [Genre]
    var spokenLanguages: [SpokenLanguage]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, homepage, budget, revenue, runtime, status, genres
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case spokenLanguages = "spoken_languages"
    }

    init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: String,
        posterPath: String,
        homepage: String,
        budget: Int,
        revenue: Int,
        runtime: Int,
        status: String,
        genres: [Genre],
        spokenLanguages: [SpokenLanguage]
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.runtime = runtime
        self.status = status
        self.genres = genres
        self.spokenLanguages = spokenLanguages
    }

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let overview = try container.decode(String.self, forKey: .overview)
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let posterPath = try container.decode(String.self, forKey: .posterPath)
        let homepage = try container.decode(String.self, forKey: .homepage)
        let budget = try container.decode(Int.self, forKey: .budget)
        let revenue = try container.decode(Int.self, forKey: .revenue)
        let runtime = try container.decode(Int.self, forKey: .runtime)
        let status = try container.decode(String.self, forKey: .status)
        let genres = try container.decode([Genre].self, forKey: .genres)
        let spokenLanguages = try container.decode([SpokenLanguage].self, forKey: .spokenLanguages)

        self.init(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            homepage: homepage,
            budget: budget,
            revenue: revenue,
            runtime: runtime,
            status: status,
            genres: genres,
            spokenLanguages: spokenLanguages
        )
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(overview)
        hasher.combine(releaseDate)
        hasher.combine(posterPath)
        hasher.combine(homepage)
        hasher.combine(budget)
        hasher.combine(revenue)
        hasher.combine(runtime)
        hasher.combine(status)
        hasher.combine(genres)
        hasher.combine(spokenLanguages)
    }

    // MARK: - Equatable
    static func == (lhs: MovieItemDetails, rhs: MovieItemDetails) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.overview == rhs.overview &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.posterPath == rhs.posterPath &&
            lhs.homepage == rhs.homepage &&
            lhs.budget == rhs.budget &&
            lhs.revenue == rhs.revenue &&
            lhs.runtime == rhs.runtime &&
            lhs.status == rhs.status &&
            lhs.genres == rhs.genres &&
            lhs.spokenLanguages == rhs.spokenLanguages
    }
}

@Model
class Genre: Decodable, Hashable {
    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    // Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.init(id: id, name: name)
    }

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

@Model
class SpokenLanguage: Decodable, Hashable {
    var englishName: String
    var name: String

    init(englishName: String, name: String) {
        self.englishName = englishName
        self.name = name
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let englishName = try container.decode(String.self, forKey: .englishName)
        let name = try container.decode(String.self, forKey: .name)
        self.init(englishName: englishName, name: name)
    }

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(englishName)
        hasher.combine(name)
    }

    static func == (lhs: SpokenLanguage, rhs: SpokenLanguage) -> Bool {
        return lhs.englishName == rhs.englishName && lhs.name == rhs.name
    }
}

