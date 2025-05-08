import Foundation
import Combine

class ArticleService {
    private let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&sort_by=popularity.desc&page=1")!

    func fetchArticles() -> AnyPublisher<[Article], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Article].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
