import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: CharacterListView()) {
                    Label("Characters", systemImage: "person.3.fill")
                        .font(.title2)
                        .padding(.vertical, 8)
                }
                NavigationLink(destination: LocationListView()) {
                    Label("Locations", systemImage: "globe")
                        .font(.title2)
                        .padding(.vertical, 8)
                }
                NavigationLink(destination: EpisodeListView()) {
                    Label("Episodes", systemImage: "tv.fill")
                        .font(.title2)
                        .padding(.vertical, 8)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Rick & Morty Wiki")
        }
    }
}
