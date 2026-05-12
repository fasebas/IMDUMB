import Foundation

protocol GetShowImagesUseCaseProtocol {
    func execute(showId: Int, completion: @escaping (Result<[ShowImageResource], Error>) -> Void)
}

class GetShowImagesUseCase: GetShowImagesUseCaseProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func execute(showId: Int, completion: @escaping (Result<[ShowImageResource], Error>) -> Void) {
        let url = "https://api.tvmaze.com/shows/\(showId)/images"
        networkService.request(url, completion: completion)
    }
}
