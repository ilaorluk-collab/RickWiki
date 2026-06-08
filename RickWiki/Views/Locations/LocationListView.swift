import SwiftUI

struct LocationListView: View {
    @StateObject private var viewModel = LocationListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.locations.isEmpty {
                ProgressView("Loading locations...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if let error = viewModel.errorMessage, viewModel.locations.isEmpty {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .tint(.green)
                .listRowBackground(Color.clear)
            } else {
                ForEach(Array(viewModel.locations.enumerated()), id: \.element.id) { index, location in
                    NavigationLink(destination: LocationDetailView(location: location)) {
                        LocationRow(location: location)
                    }
                    .tint(.green)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
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
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.clear) // ✅ ДОБАВИЛ: прозрачный фон List
        .navigationTitle("Locations")
        .toolbarBackground(.hidden, for: .navigationBar) // ✅ ДОБАВИЛ: прозрачный навбар
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadNextPage()
        }
        // ❌ УБРАЛ .portalBackground() — фон идёт от OnboardingView
    }
}

private struct LocationRow: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)
                .foregroundColor(.primary)
            HStack(spacing: 4) {
                Text(location.type)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.6))
                Text("·")
                    .foregroundColor(.primary.opacity(0.3))
                Text(location.dimension)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.6))
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
