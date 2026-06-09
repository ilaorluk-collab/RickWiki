import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 1. Картинка на всю ширину экрана
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Заполняем всю ширину
                            .frame(maxWidth: .infinity)
                            .frame(height: 350) // Фиксированная высота для сочности
                            .clipped()
                    case .failure:
                        Image(systemName: "person.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                            .frame(height: 350)
                    case .empty:
                        ProgressView()
                            .frame(height: 350)
                    @unknown default:
                        EmptyView()
                    }
                }

                // 2. Блок информации с отступами на чистом белом фоне
                VStack(alignment: .leading, spacing: 16) {
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
                .padding(24) // Отступы только для текста
                .background(.white)
            }
        }
        .background(.white) // Белый фон для всего экрана
        .scrollContentBackground(.hidden)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        // Модификатор портала убрали совсем — здесь чистый светлый дизайн
    }
}
