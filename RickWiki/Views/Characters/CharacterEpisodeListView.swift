import SwiftUI

struct CharacterEpisodeListView: View {
    let character: Character
    @State private var episodes: [Episode] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading episodes...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if let error = errorMessage {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .tint(.green)
                .listRowBackground(Color.clear)
            } else {
                ForEach(episodes) { episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        EpisodeRow(episode: episode)
                    }
                    .tint(.green)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Episodes (\(episodes.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .portalBackground(opacity: 0.45)
        .task {
            await loadEpisodes()
        }
    }

    private func loadEpisodes() async {
        let ids = character.episode.compactMap { urlString in
            Int(urlString.split(separator: "/").last ?? "")
        }
        guard !ids.isEmpty else {
            isLoading = false
            errorMessage = "No episodes found for this character"
            return
        }
        do {
            episodes = try await APIClient.shared.fetchMultipleEpisodes(ids: ids)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
