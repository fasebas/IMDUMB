import Foundation

// Entidad que agrupa programas por género (Categoría)
struct ShowCategory {
    let title: String
    let shows: [Show]
}

// Entidad que representa un programa o película
struct Show: Codable {
    let id: Int
    let name: String
    let genres: [String]
    let rating: Rating?
    let image: ShowImage?
    let summary: String? // Contiene HTML según el reto
}

struct Rating: Codable {
    let average: Double?
}

struct ShowImage: Codable {
    let medium: String?
    let original: String?
}

// Entidad para el detalle (Actores/Cast)
struct Cast: Codable {
    let person: Person
}

struct Person: Codable {
    let name: String
}
