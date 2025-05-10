import Foundation
import SwiftData

class MovieItemDetails: Identifiable, Codable {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var posterPath: String
    var homepage: String?
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
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct SpokenLanguage: Codable {
    let englishName: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
    }
}

