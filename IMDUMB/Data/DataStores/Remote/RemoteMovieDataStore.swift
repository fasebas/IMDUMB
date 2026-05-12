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

