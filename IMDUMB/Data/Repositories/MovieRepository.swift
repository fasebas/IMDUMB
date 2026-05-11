import Foundation

protocol MovieRepositoryProtocol {
    func getMoviesGroupedByCategory(completion: @escaping (Result<[ShowCategory], Error>) -> Void)
}

class MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://api.tvmaze.com/shows"
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getMoviesGroupedByCategory(completion: @escaping (Result<[ShowCategory], Error>) -> Void) {
        networkService.request(baseURL) { (result: Result<[Show], Error>) in
            switch result {
            case .success(let shows):
                let grouped = self.groupShowsByGenre(shows)
                completion(.success(grouped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func groupShowsByGenre(_ shows: [Show]) -> [ShowCategory] {
        var genreDict: [String: [Show]] = [:]
        
        for show in shows {
            for genre in show.genres {
                if genreDict[genre] == nil {
                    genreDict[genre] = []
                }
                genreDict[genre]?.append(show)
            }
        }
        
        // Convertimos el diccionario a un array de categorías ordenado
        return genreDict.map { ShowCategory(title: $0.key, shows: $0.value) }
            .sorted { $0.title < $1.title }
    }
}
