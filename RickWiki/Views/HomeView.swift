import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            NavigationLink(destination: CharacterListView()) {
                Label("Characters", systemImage: "person.3.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            NavigationLink(destination: LocationListView()) {
                Label("Locations", systemImage: "globe")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            NavigationLink(destination: EpisodeListView()) {
                Label("Episodes", systemImage: "tv.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Rick & Morty Wiki")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
