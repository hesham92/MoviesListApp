import Foundation
import Combine

class NetworkClient {
    func getData<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            // Log the error
                            print("Error occurred: \(error)")
                        case .finished:
                            break
                        }
                    })
            .eraseToAnyPublisher()
    }
}
