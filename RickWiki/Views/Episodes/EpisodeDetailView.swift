import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode

    var body: some View {
        List {
            LabeledContent("Name", value: episode.name)
            LabeledContent("Air Date", value: episode.airDate)
            LabeledContent("Episode", value: episode.episode)
            LabeledContent("Characters", value: "\(episode.characters.count)")
            LabeledContent("Created", value: episode.created)
        }
        .navigationTitle(episode.episode)
        .navigationBarTitleDisplayMode(.inline)
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
