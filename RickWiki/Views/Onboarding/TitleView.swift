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
    @State private var isPulsing = false

    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                Image("TitleHero")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.horizontal, 24)
                    .overlay(alignment: .bottom) {
                        ForEach(drops) { drop in
                            Teardrop()
                                .fill(.green)
                                .frame(width: 5, height: 9)
                                .offset(x: drop.x, y: drop.offset)
                                .opacity(drop.opacity)
                        }
                    }

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.green.opacity(0.6))
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
        let x = CGFloat.random(in: 20...300)
        var drop = Drop(x: x, offset: -8)
        drops.append(drop)

        let id = drop.id
        withAnimation(.easeOut(duration: 0.6)) {
            guard let i = drops.firstIndex(where: { $0.id == id }) else { return }
            drops[i].offset = 40
            drops[i].opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            drops.removeAll { $0.id == id }
        }
    }
}
