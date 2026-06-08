import SwiftUI

struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.episodes.isEmpty {
                ProgressView("Loading episodes...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            } else if let error = viewModel.errorMessage, viewModel.episodes.isEmpty {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
            } else {
                ForEach(Array(viewModel.episodes.enumerated()), id: \.element.id) { index, episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        EpisodeRow(episode: episode)
                    }
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
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Episodes")
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadNextPage()
        }
    }
}

private struct EpisodeRow: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.name)
                .font(.headline)
            HStack(spacing: 4) {
                Text(episode.episode)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("·")
                    .foregroundStyle(.tertiary)
                Text(episode.airDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
