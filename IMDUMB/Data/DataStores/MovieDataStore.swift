import Foundation

protocol MovieDataStoreProtocol {
    func fetchShows(completion: @escaping (Result<[Show], Error>) -> Void)
}

class RemoteMovieDataStore: MovieDataStoreProtocol {
    private let networkService: NetworkServiceProtocol
    private let url = "https://api.tvmaze.com/shows"
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        networkService.request(url, completion: completion)
    }
}

class MockMovieDataStore: MovieDataStoreProtocol {
    func fetchShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        // Simulación de datos locales para QA o Tests
        let mockShow = Show(id: 1, name: "Mock Show", genres: ["Action"], rating: Rating(average: 9.9), image: nil, summary: "Esto es un mock")
        completion(.success([mockShow]))
    }
}
