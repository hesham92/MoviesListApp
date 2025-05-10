import Factory
import SwiftData

extension Container {
    var moviesListRepository: Factory<MoviesListRepository> {
        self { MoviesListRepositoryImpl() }
    }
    
    var networkClient: Factory<NetworkClient> {
        self { NetworkClientImpl() }
    }
    
    var networkMonitor: Factory<NetworkMonitor> {
        self { NetworkMonitorImpl() }
    }
    
    var moviesCache: Factory<MoviesCache> {
        self { MoviesCacheImpl(modelContext: try! ModelContext(ModelContainer(for: MovieItem.self))) }.singleton
    }
}
