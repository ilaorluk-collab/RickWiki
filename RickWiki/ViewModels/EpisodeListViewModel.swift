import Foundation

@MainActor
final class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var canLoadMore = true
    private let apiClient = APIClient.shared

    func loadNextPage() async {
        // Защита: не грузим следующую страницу, если уже идет загрузка (пагинация или полный рефреш)
        guard !isLoadingMore, !isLoading, canLoadMore else { return }
        isLoadingMore = true
        if errorMessage != nil { errorMessage = nil }

        do {
            let response = try await apiClient.fetchEpisodes(page: currentPage)
            episodes.append(contentsOf: response.results)
            currentPage += 1
            canLoadMore = currentPage <= response.info.pages
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingMore = false
    }

    func refresh() async {
        // Защита от двойного вызова: если рефреш или пагинация уже идут, игнорируем новые вызовы
        guard !isLoading, !isLoadingMore else { return }
        
        isLoading = true
        if errorMessage != nil { errorMessage = nil } // Сбрасываем ошибку перед новым запросом
        currentPage = 1
        canLoadMore = true
        episodes = []
        
        // Вызываем загрузку первой страницы
        // Так как isLoading уже true, метод loadNextPage() пропустит свои guard-проверки корректно
        do {
            let response = try await apiClient.fetchEpisodes(page: currentPage)
            episodes = response.results
            currentPage += 1
            canLoadMore = currentPage <= response.info.pages
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
