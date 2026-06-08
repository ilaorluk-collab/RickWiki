import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error: \(code)"
        }
    }
}

final class APIClient {
    static let shared = APIClient()
    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
    }

    // MARK: - Characters

    func fetchCharacters(page: Int? = nil, filter: CharacterFilter? = nil) async throws -> APIResponse<Character> {
        let endpoint = RickMortyAPI.characters(page: page, filter: filter)
        return try await request(endpoint)
    }

    func fetchCharacter(id: Int) async throws -> Character {
        let endpoint = RickMortyAPI.character(id: id)
        return try await request(endpoint)
    }

    func fetchMultipleCharacters(ids: [Int]) async throws -> [Character] {
        let endpoint = RickMortyAPI.multipleCharacters(ids: ids)
        return try await requestArray(endpoint)
    }

    // MARK: - Locations

    func fetchLocations(page: Int? = nil, filter: LocationFilter? = nil) async throws -> APIResponse<Location> {
        let endpoint = RickMortyAPI.locations(page: page, filter: filter)
        return try await request(endpoint)
    }

    func fetchLocation(id: Int) async throws -> Location {
        let endpoint = RickMortyAPI.location(id: id)
        return try await request(endpoint)
    }

    func fetchMultipleLocations(ids: [Int]) async throws -> [Location] {
        let endpoint = RickMortyAPI.multipleLocations(ids: ids)
        return try await requestArray(endpoint)
    }

    // MARK: - Episodes

    func fetchEpisodes(page: Int? = nil, filter: EpisodeFilter? = nil) async throws -> APIResponse<Episode> {
        let endpoint = RickMortyAPI.episodes(page: page, filter: filter)
        return try await request(endpoint)
    }

    func fetchEpisode(id: Int) async throws -> Episode {
        let endpoint = RickMortyAPI.episode(id: id)
        return try await request(endpoint)
    }

    func fetchMultipleEpisodes(ids: [Int]) async throws -> [Episode] {
        let endpoint = RickMortyAPI.multipleEpisodes(ids: ids)
        return try await requestArray(endpoint)
    }

    // MARK: - Request helpers

    private func request<T: Decodable>(_ endpoint: RickMortyAPI) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        let data: Data
        do {
            (data, _) = try await session.data(from: url)
        } catch {
            throw APIError.requestFailed(error)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    private func requestArray<T: Decodable>(_ endpoint: RickMortyAPI) async throws -> [T] {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        let data: Data
        do {
            (data, _) = try await session.data(from: url)
        } catch {
            throw APIError.requestFailed(error)
        }

        do {
            return try decoder.decode([T].self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
