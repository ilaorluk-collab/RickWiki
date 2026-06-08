import SwiftUI

struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.episodes.isEmpty {
                ProgressView("Loading episodes...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if let error = viewModel.errorMessage, viewModel.episodes.isEmpty {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .tint(.green)
                .listRowBackground(Color.clear)
            } else {
                ForEach(Array(viewModel.episodes.enumerated()), id: \.element.id) { index, episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        EpisodeRow(episode: episode)
                    }
                    .tint(.green)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear {
                        if index == viewModel.episodes.count - 1 {
                            Task { await viewModel.loadNextPage() }
                        }
                    }
                }

                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Episodes")
        .toolbarBackground(.hidden, for: .navigationBar)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadNextPage()
        }
    }
}

struct EpisodeRow: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.name)
                .font(.headline)
                .foregroundColor(.primary)
            HStack(spacing: 4) {
                Text(episode.episode)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.6))
                Text("·")
                    .foregroundColor(.primary.opacity(0.3))
                Text(episode.airDate)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        EpisodeListView()
    }
}
