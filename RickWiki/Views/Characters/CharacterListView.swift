import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                ProgressView("Loading characters...")
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else if let error = viewModel.errorMessage, viewModel.characters.isEmpty {
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .tint(.green)
                .listRowBackground(Color.clear)
            } else {
                ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRow(character: character)
                    }
                    .tint(.green)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear {
                        if index == viewModel.characters.count - 1 {
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
        .background(.clear) // ✅ ВОТ ЧТО НАДО ДОБАВИТЬ
        .navigationTitle("Characters")
        .toolbarBackground(.hidden, for: .navigationBar) // ✅ И ЭТО
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadNextPage()
        }
        // ❌ УБРАТЬ .portalBackground() — он перекрывает родительский фон
    }
}

// CharacterRow без изменений
struct CharacterRow: View {
    let character: Character

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(.primary.opacity(0.5))
                case .empty:
                    ProgressView()
                        .tint(.green)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack(spacing: 6) {
                    statusDot(for: character.status)
                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func statusDot(for status: CharacterStatus) -> some View {
        Circle()
            .fill(statusColor(for: status))
            .frame(width: 8, height: 8)
    }

    private func statusColor(for status: CharacterStatus) -> Color {
        switch status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        CharacterListView()
    }
}
