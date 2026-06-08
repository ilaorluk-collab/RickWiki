import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode

    var body: some View {
        List {
            Group {
                LabeledContent("Name", value: episode.name)
                LabeledContent("Air Date", value: episode.airDate)
                LabeledContent("Episode", value: episode.episode)
                NavigationLink(destination: EpisodeCharacterListView(episode: episode)) {
                    LabeledContent("Characters", value: "\(episode.characters.count)")
                }
                .tint(.green)
                LabeledContent("Created", value: episode.created)
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(episode.episode)
        .navigationBarTitleDisplayMode(.inline)
        .portalBackground(opacity: 0.45)
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailView(
            episode: Episode(
                id: 1,
                name: "Pilot",
                airDate: "December 2, 2013",
                episode: "S01E01",
                characters: ["https://rickandmortyapi.com/api/character/1"],
                url: "",
                created: "2017-11-10T12:56:33.798Z"
            )
        )
    }
}
