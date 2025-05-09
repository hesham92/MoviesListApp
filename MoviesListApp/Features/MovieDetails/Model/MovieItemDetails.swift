import Foundation
import SwiftData

class MovieItemDetails: Identifiable, Codable {
    var id: Int
    var title: String
    var originalTitle: String
    var overview: String
    var releaseDate: String
    var posterPath: String
    var backdropPath: String?
    var homepage: String?
    var budget: Int
    var revenue: Int
    var runtime: Int?
    var status: String
    var tagline: String?
    var voteAverage: Double
    var voteCount: Int
    var genres: [Genre]
    var spokenLanguages: [SpokenLanguage]
    var productionCountries: [ProductionCountry]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, homepage, budget, revenue, runtime, status, tagline
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres, spokenLanguages = "spoken_languages"
        case productionCountries = "production_countries"
    }

    init(
        id: Int,
        title: String,
        originalTitle: String,
        overview: String,
        releaseDate: String,
        posterPath: String,
        backdropPath: String? = nil,
        homepage: String? = nil,
        budget: Int,
        revenue: Int,
        runtime: Int? = nil,
        status: String,
        tagline: String? = nil,
        voteAverage: Double,
        voteCount: Int,
        genres: [Genre],
        spokenLanguages: [SpokenLanguage],
        productionCountries: [ProductionCountry]
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genres = genres
        self.spokenLanguages = spokenLanguages
        self.productionCountries = productionCountries
    }
}

// Supporting nested types

struct Genre: Codable {
    let id: Int
    let name: String
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

