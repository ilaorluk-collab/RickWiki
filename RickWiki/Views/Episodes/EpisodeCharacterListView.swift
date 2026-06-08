import SwiftUI

struct EpisodeCharacterListView: View {
    let episode: Episode
    @State private var characters: [Character] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading characters...")
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
                ForEach(characters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRow(character: character)
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
        .navigationTitle("Characters (\(characters.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .portalBackground(opacity: 0.45)
        .task {
            await loadCharacters()
        }
    }

    private func loadCharacters() async {
        let ids = episode.characters.compactMap { urlString in
            Int(urlString.split(separator: "/").last ?? "")
        }
        guard !ids.isEmpty else {
            isLoading = false
            errorMessage = "No characters found for this episode"
            return
        }
        do {
            characters = try await APIClient.shared.fetchMultipleCharacters(ids: ids)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
