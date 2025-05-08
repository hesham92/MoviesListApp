//
//  MoviesListAppApp.swift
//  MoviesListApp
//
//  Created by Hesham on 08/05/2025.
//

import SwiftUI
import SwiftData

@main
struct MoviesListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleListView()
        }
        .modelContainer(for: PopularMovieList.self)
    }
}

