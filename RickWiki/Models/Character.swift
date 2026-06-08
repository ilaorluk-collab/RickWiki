import Foundation

struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct CharacterOrigin: Codable, Hashable {
    let name: String
    let url: String
}

struct CharacterLocation: Codable, Hashable {
    let name: String
    let url: String
}

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

struct APIResponse<T: Codable>: Codable {
    let info: APIInfo
    let results: [T]
}

struct APIInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
