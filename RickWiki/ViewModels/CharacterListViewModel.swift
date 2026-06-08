import Foundation

@MainActor
final class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var canLoadMore = true
    private let apiClient = APIClient.shared

    func loadNextPage() async {
        guard !isLoadingMore, canLoadMore else { return }
        isLoadingMore = true
        if errorMessage != nil { errorMessage = nil }

        do {
            let response = try await apiClient.fetchCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
            currentPage += 1
            canLoadMore = currentPage <= response.info.pages
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingMore = false
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        currentPage = 1
        canLoadMore = true
        characters = []
        await loadNextPage()
    }
}
