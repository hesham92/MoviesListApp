import Foundation

enum ApiEndpoints {
    case moviePopular(page: Int)
    case movieDetail(id: Int)
}

extension ApiEndpoints: Endpoint {
    var path: String {
        switch self {
        case .moviePopular(let page):
            return "movie/popular?page=\(page)"
        case .movieDetail(let id):
            return "movie/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .moviePopular, .movieDetail:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .moviePopular, .movieDetail:
            return [
                "Authorization": "Bearer \(API_KEY)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .moviePopular, .movieDetail:
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

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}


let API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjM3OWI4NWNkNWVmZTlkMGZiOGQ2MzdlMTcyMjMxZCIsIm5iZiI6MS43NDY3MDA4OTI5MTkwMDAxZSs5LCJzdWIiOiI2ODFjOGE1Y2IxZjkwYTlkMTY2M2I3ZDUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.HGGGv2MD4sNjrGkj2PUjvfM25D8UTYBjbuqiNDS13O8"
