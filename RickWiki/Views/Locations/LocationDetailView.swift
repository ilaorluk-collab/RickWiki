import SwiftUI

struct LocationDetailView: View {
    let location: Location

    var body: some View {
        List {
            Group {
                LabeledContent("Name", value: location.name)
                LabeledContent("Type", value: location.type)
                LabeledContent("Dimension", value: location.dimension)
                LabeledContent("Residents", value: "\(location.residents.count)")
                LabeledContent("Created", value: location.created)
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        .portalBackground(opacity: 0.45)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(
            location: Location(
                id: 1,
                name: "Earth (C-137)",
                type: "Planet",
                dimension: "Dimension C-137",
                residents: ["https://rickandmortyapi.com/api/character/1"],
                url: "",
                created: "2017-11-10T12:42:04.162Z"
            )
        )
    }
}
