import Foundation

protocol GetMoviesUseCaseProtocol {
    func execute(completion: @escaping (Result<[ShowCategory], Error>) -> Void)
}

// SOLID: Dependency Inversion Principle (DIP)
// El Caso de Uso depende de una abstracción (MovieRepositoryProtocol) y no de una implementación concreta.
// Esto permite que el componente sea testeable y desacoplado de la fuente de datos.
class GetMoviesUseCase: GetMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    // Inyección de dependencias (Principio SOLID: Dependency Inversion)
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[ShowCategory], Error>) -> Void) {
        repository.getMoviesGroupedByCategory { result in
            // Aquí podríamos aplicar lógica de negocio adicional (filtrado, ordenado extra, etc.)
            completion(result)
        }
    }
}
