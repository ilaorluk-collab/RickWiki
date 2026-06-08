import SwiftUI

struct LocationListView: View {
    @StateObject private var viewModel = LocationListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.locations.isEmpty {
                ProgressView("Loading locations...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            } else if let error = viewModel.errorMessage, viewModel.locations.isEmpty {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
            } else {
                ForEach(Array(viewModel.locations.enumerated()), id: \.element.id) { index, location in
                    NavigationLink(destination: LocationDetailView(location: location)) {
                        LocationRow(location: location)
                    }
                    .onAppear {
                        if index == viewModel.locations.count - 1 {
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
        .navigationTitle("Locations")
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadNextPage()
        }
    }
}

private struct LocationRow: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)
            HStack(spacing: 4) {
                Text(location.type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("·")
                    .foregroundStyle(.tertiary)
                Text(location.dimension)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        LocationListView()
    }
}
