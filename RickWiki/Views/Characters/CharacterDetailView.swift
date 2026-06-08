import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 120))
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: 300)

                VStack(alignment: .leading, spacing: 12) {
                    LabeledContent("Status", value: character.status.rawValue)
                    LabeledContent("Species", value: character.species)
                    LabeledContent("Gender", value: character.gender)
                    LabeledContent("Origin", value: character.origin.name)
                    LabeledContent("Location", value: character.location.name)
                    NavigationLink(destination: CharacterEpisodeListView(character: character)) {
                        LabeledContent("Episodes", value: "\(character.episode.count)")
                    }
                    .tint(.green)
                }
                .padding()
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .portalBackground(opacity: 0.45)
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(
            character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: .alive,
                species: "Human",
                type: "",
                gender: "Male",
                origin: CharacterOrigin(name: "Earth (C-137)", url: ""),
                location: CharacterLocation(name: "Citadel of Ricks", url: ""),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: ["https://rickandmortyapi.com/api/episode/1"],
                url: "",
                created: ""
            )
        )
    }
}
