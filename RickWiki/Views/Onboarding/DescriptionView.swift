import SwiftUI

struct DescriptionView: View {
    @State private var hasAppeared = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                // Персонажи Рика и Морти (Появление с микро-задержкой)
                Image("RickMortyHero")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .scaleEffect(hasAppeared ? 1 : 0.7)
                    .opacity(hasAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: hasAppeared)

                // Блок с текстом (Появление следом)
                VStack(spacing: 12) {
                    Text("RickWiki")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        // Наш каноничный кислотно-зеленый цвет
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Your ultimate guide to the Rick and Morty universe. Explore characters, dimensions, and episodes. All dimensions under your control.")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 32)
                }
                .scaleEffect(hasAppeared ? 1 : 0.8)
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: hasAppeared)

                Spacer()

                // Индикатор скролла вниз
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            hasAppeared = true
        }
    }
}

#Preview {
    DescriptionView()
}
