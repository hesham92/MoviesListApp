// Router.swift
import Foundation
import SwiftUI
import Observation
@Observable
class Router {
    var path = NavigationPath()

    func navigateToSetup(id: Int) {
        path.append(Route.setup(id: id))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case setup(id: Int)
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
            case let .setup(id):
                MovieDetailsView(movieId: id)
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
