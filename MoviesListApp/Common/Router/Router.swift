// Router.swift
import Foundation
import SwiftUI
import Observation
@Observable
class Router {
    var path = NavigationPath()

    func navigateToMovieItemDetails(movieItemDetails: MovieItemDetails) {
        path.append(Route.movieItemDetails(movieItemDetails: movieItemDetails))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case movieItemDetails(movieItemDetails: MovieItemDetails)
}

extension View {
    public func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}

struct RouterViewModifier: ViewModifier {
    @State private var router = Router()
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case let .movieItemDetails(movieItemDetails):
                MovieDetailsView(movieItemDetails: movieItemDetails)
            }
        }
        .environment(router)
    }
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}
