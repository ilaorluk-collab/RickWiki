import SwiftUI

private struct Drop: Identifiable {
    let id = UUID()
    let x: CGFloat
    var offset: CGFloat = 0
    var opacity: Double = 1
}

// MARK: - Каплявидная форма
private struct Teardrop: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: 0)) // Верхняя точка
        
        // Левая сторона
        path.addCurve(
            to: CGPoint(x: width / 2, y: height),
            control1: CGPoint(x: 0, y: height * 0.6),
            control2: CGPoint(x: width / 2, y: height)
        )
        
        // Правая сторона
        path.addCurve(
            to: CGPoint(x: width / 2, y: 0),
            control1: CGPoint(x: width / 2, y: height),
            control2: CGPoint(x: width, y: height * 0.6)
        )
        
        return path
    }
}

struct TitleView: View {
    @State private var drops: [Drop] = []
    @State private var textSize: CGSize = .zero
    @State private var isPulsing = false

    private let text = "Rick and Morty"
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                Text(text)
                    .font(.system(size: 44, weight: .black))
                    .foregroundColor(.green) // ✅ Текст зелёный
                    .background(GeometryReader { geo in
                        Color.clear.onAppear { textSize = geo.size }
                    })
                    .overlay(alignment: .topLeading) {
                        ForEach(drops) { drop in
                            Teardrop() // ✅ Каплевидная форма
                                .fill(.green) // ✅ Зелёные капли
                                .frame(width: 5, height: 9) // Узкая капля
                                .offset(x: drop.x, y: textSize.height + drop.offset)
                                .opacity(drop.opacity)
                        }
                    }

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.green.opacity(0.6)) // ✅ Стрелка тоже зелёная
                    .scaleEffect(isPulsing ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isPulsing)
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onReceive(timer) { _ in spawnDrop() }
        .onAppear { isPulsing = true }
    }

    private func spawnDrop() {
        guard textSize.width > 0 else { return }

        let charWidth = textSize.width / CGFloat(text.count)
        let index = Int.random(in: 0..<text.count)
        let x = CGFloat(index) * charWidth + charWidth / 2

        let drop = Drop(x: x)
        drops.append(drop)

        let id = drop.id
        withAnimation(.easeOut(duration: 0.6)) {
            guard let i = drops.firstIndex(where: { $0.id == id }) else { return }
            drops[i].offset = 30
            drops[i].opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            drops.removeAll { $0.id == id }
        }
    }
}
