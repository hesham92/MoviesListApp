//
//  MoviesListAppApp.swift
//  MoviesListApp
//
//  Created by Hesham on 08/05/2025.
//

import SwiftUI
import SwiftData

@main
struct MoviesListApp: App {
    var body: some Scene {
        WindowGroup {
            MoviesListView()
        }
        .modelContainer(for: PopularMovieList.self)
    }
}
