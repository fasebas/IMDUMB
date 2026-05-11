import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void)
}

// SOLID: Single Responsibility Principle (SRP)
// Esta clase tiene la única responsabilidad de gestionar las peticiones de red de forma genérica.
// No conoce nada sobre lógica de negocio o modelos específicos.
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
