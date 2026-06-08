import Foundation

struct CharacterFilter {
    var name: String?
    var status: CharacterStatus?
    var species: String?
    var type: String?
    var gender: String?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let name { items.append(URLQueryItem(name: "name", value: name)) }
        if let status { items.append(URLQueryItem(name: "status", value: status.rawValue.lowercased())) }
        if let species { items.append(URLQueryItem(name: "species", value: species)) }
        if let type { items.append(URLQueryItem(name: "type", value: type)) }
        if let gender { items.append(URLQueryItem(name: "gender", value: gender)) }
        return items
    }
}

struct LocationFilter {
    var name: String?
    var type: String?
    var dimension: String?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let name { items.append(URLQueryItem(name: "name", value: name)) }
        if let type { items.append(URLQueryItem(name: "type", value: type)) }
        if let dimension { items.append(URLQueryItem(name: "dimension", value: dimension)) }
        return items
    }
}

struct EpisodeFilter {
    var name: String?
    var episode: String?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let name { items.append(URLQueryItem(name: "name", value: name)) }
        if let episode { items.append(URLQueryItem(name: "episode", value: episode)) }
        return items
    }
}
