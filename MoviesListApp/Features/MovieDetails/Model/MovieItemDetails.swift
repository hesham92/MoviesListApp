import Foundation
import SwiftData

class MovieItemDetails: Identifiable, Codable, Hashable {
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

    // Conform to Hashable by implementing hash(into:) method
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

    // Equatable already implemented, no need to modify
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

struct Genre: Codable, Hashable {
    let id: Int
    let name: String

    // Hashable conformance is automatically provided for structs with only simple types like Int and String.
}

struct SpokenLanguage: Codable, Hashable {
    let englishName: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
    }
}

