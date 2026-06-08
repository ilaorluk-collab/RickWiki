import Foundation

enum RickMortyAPI {
    static let baseURL = "https://rickandmortyapi.com/api"

    case characters(page: Int? = nil, filter: CharacterFilter? = nil)
    case character(id: Int)
    case multipleCharacters(ids: [Int])
    case locations(page: Int? = nil, filter: LocationFilter? = nil)
    case location(id: Int)
    case multipleLocations(ids: [Int])
    case episodes(page: Int? = nil, filter: EpisodeFilter? = nil)
    case episode(id: Int)
    case multipleEpisodes(ids: [Int])

    var url: URL? {
        var components = URLComponents(string: Self.baseURL)

        switch self {
        case .characters(let page, let filter):
            components?.path += "/character"
            components?.queryItems = Self.makeQueryItems(page: page, filter: filter?.queryItems)
        case .character(let id):
            components?.path += "/character/\(id)"
        case .multipleCharacters(let ids):
            components?.path += "/character/\(ids.map(String.init).joined(separator: ","))"

        case .locations(let page, let filter):
            components?.path += "/location"
            components?.queryItems = Self.makeQueryItems(page: page, filter: filter?.queryItems)
        case .location(let id):
            components?.path += "/location/\(id)"
        case .multipleLocations(let ids):
            components?.path += "/location/\(ids.map(String.init).joined(separator: ","))"

        case .episodes(let page, let filter):
            components?.path += "/episode"
            components?.queryItems = Self.makeQueryItems(page: page, filter: filter?.queryItems)
        case .episode(let id):
            components?.path += "/episode/\(id)"
        case .multipleEpisodes(let ids):
            components?.path += "/episode/\(ids.map(String.init).joined(separator: ","))"
        }

        return components?.url
    }

    private static func makeQueryItems(page: Int?, filter: [URLQueryItem]?) -> [URLQueryItem]? {
        var items: [URLQueryItem] = []
        if let page { items.append(URLQueryItem(name: "page", value: String(page))) }
        if let filter { items.append(contentsOf: filter) }
        return items.isEmpty ? nil : items
    }
}
