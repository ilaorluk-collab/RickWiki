import SwiftUI

struct TitleView: View {
    // Состояние для управления смещением парения
    @State private var isFloating = false
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                // Твоя PNG надпись/арт
                Image("TitleHero")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.horizontal, 24)
                    // ИСПРАВЛЕНО: Минимальное смещение всего на 6 пикселей вверх/вниз
                    .offset(y: isFloating ? -6 : 6)

                Spacer()

                // Стрелочка вниз
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.green.opacity(0.6))
                    .scaleEffect(isPulsing ? 1.3 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            // Запускаем обе анимации при появлении экрана
            isFloating = true
            isPulsing = true
        }
    }
}
