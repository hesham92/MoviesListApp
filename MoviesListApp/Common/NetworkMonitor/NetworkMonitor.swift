import Network
import Combine

protocol NetworkMonitor {
    var isConnected: Bool { get }
    var isConnectedPublisher: any Publisher<Bool, Never> { get }
}

class NetworkMonitorImpl: NetworkMonitor, ObservableObject {
    var isConnectedPublisher: any Publisher<Bool, Never> {
        $isConnected
    }
    
    @Published var isConnected: Bool = false

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
