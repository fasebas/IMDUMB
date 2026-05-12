import Foundation

protocol GetCastUseCaseProtocol {
    func execute(showId: Int, completion: @escaping (Result<[Cast], Error>) -> Void)
}

class GetCastUseCase: GetCastUseCaseProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func execute(showId: Int, completion: @escaping (Result<[Cast], Error>) -> Void) {
        let url = "https://api.tvmaze.com/shows/\(showId)/cast"
        networkService.request(url, completion: completion)
    }
}
