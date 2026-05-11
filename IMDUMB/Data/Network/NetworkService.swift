import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
