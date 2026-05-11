import Foundation

class MockMovieDataStore: MovieDataStoreProtocol {
    func fetchShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        // Simulación de datos locales para QA o Tests
        let mockShow = Show(
            id: 1,
            name: "Mock Show (QA Mode)",
            genres: ["Action", "Sci-Fi"],
            rating: Rating(average: 9.9),
            image: nil,
            summary: "<p>Este es un <b>Show de Prueba</b> para validar el comportamiento sin conexión o pruebas de QA.</p>"
        )
        completion(.success([mockShow]))
    }
}
