import Foundation

let API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjM3OWI4NWNkNWVmZTlkMGZiOGQ2MzdlMTcyMjMxZCIsIm5iZiI6MS43NDY3MDA4OTI5MTkwMDAxZSs5LCJzdWIiOiI2ODFjOGE1Y2IxZjkwYTlkMTY2M2I3ZDUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.HGGGv2MD4sNjrGkj2PUjvfM25D8UTYBjbuqiNDS13O8"

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
}

enum ApiEndpoints {
    case moviesGenres
    case moviesList(page: Int)
    case movieDetail(id: Int)
}

extension ApiEndpoints: Endpoint {
    var path: String {
        switch self {
        case .moviesGenres:
            return "genre/movie/list?language=en"
        case .moviesList(let page):
            return "discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&page=\(page)"
        case .movieDetail(let id):
            return "movie/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .moviesGenres, .moviesList, .movieDetail:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .moviesGenres, .moviesList, .movieDetail:
            return [
                "Authorization": "Bearer \(API_KEY)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .moviesGenres, .moviesList, .movieDetail:
            return nil
        }
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
