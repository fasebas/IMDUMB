import Foundation

class LocalMovieDataStore: MovieDataStoreProtocol {
    func fetchShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        // En una implementación real, aquí se usaría CoreData o UserDefaults
        // Por ahora, devolvemos un error de "sin datos locales" para que el repositorio use el remoto
        let error = NSError(domain: "LocalDataStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No hay datos en caché local"])
        completion(.failure(error))
    }
    
    func saveShows(_ shows: [Show]) {
        // Lógica para persistir datos localmente
    }
}
