import SwiftUI

struct MovieDetailsContentViewPresentation {
    init(movieItem: MovieItemDetails) {
        self.movieItem = movieItem
    }
    
    var overviewText: String {
        return movieItem.overview
    }

    var budgetText: String {
        return "Budget: \(movieItem.budget.formatted(.currency(code: "USD")))"
    }

    var statusText: String {
        return "Status: \(movieItem.status)"
    }

    var runtimeText: String {
        return "Runtime: \(movieItem.runtime) minutes"
    }

    var revenueText: String {
        return "Revenue: \(movieItem.revenue.formatted(.currency(code: "USD")))"
    }

    var homepageText: String {
        return "Homepage: \(movieItem.homepage)"
    }

    var languagesText: String {
        return "Languages: \(movieItem.spokenLanguages.map { $0.name }.joined(separator: ", "))"
    }
    
    private let movieItem: MovieItemDetails
}

extension MovieDetailsContentViewPresentation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieItem.id)
    }
}
