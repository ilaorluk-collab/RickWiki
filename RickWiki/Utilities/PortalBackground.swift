import SwiftUI

// Модель для крупных "жидких" сгустков энергии внутри портала
struct PortalBlob: Identifiable {
    let id = UUID()
    var radiusFraction: CGFloat // Дистанция от центра (0.0 до 1.0)
    var angle: Double          // Текущий угол в радианах
    let size: CGSize           // Искаженная форма сгустка
    let color: Color
    let rotationSpeed: Double  // Скорость вращения
    let waveSpeed: Double      // Скорость "пульсации"
    let phase: Double
}

struct PortalBackground: View {
    @State private var blobs: [PortalBlob] = []
    
    // Пропорции портала из Рика и Морти (строго вертикальный эллипс)
    private let portalWidth: CGFloat = 280
    private let portalHeight: CGFloat = 450

    var body: some View {
        ZStack {
            // Глубокий темный фон приложения
            Color(red: 0.01, green: 0.02, blue: 0.01)
                .ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    // ==========================================
                    // 1. РАССЕЯННАЯ АУРА (ТУМАН ВОКРУГ ПОРТАЛА)
                    // ==========================================
                    Ellipse()
                        .fill(Color(red: 0.1, green: 0.8, blue: 0.1).opacity(0.35))
                        .frame(width: portalWidth * 1.6, height: portalHeight * 1.5)
                        .blur(radius: 65)
                        // Эффект "дыхания" тумана
                        .scaleEffect(1.0 + sin(t * 1.8) * 0.04)

                    // ==========================================
                    // 2. ВНУТРЕННЯЯ ЖИДКОСТЬ ПОРТАЛА (СТРОГО ВНУТРИ)
                    // ==========================================
                    ZStack {
                        // Базовый темно-зеленый слой портала
                        Ellipse()
                            .fill(Color(red: 0.04, green: 0.35, blue: 0.04))
                        
                        // ТЕКСТУРНЫЙ СЛОЙ: Вращающиеся градиентные спирали
                        spiralLayer(at: t, clockwise: true, speed: 25, scale: 1.1, color: Color(red: 0.1, green: 0.7, blue: 0.1))
                        spiralLayer(at: t, clockwise: false, speed: 35, scale: 0.9, color: Color(red: 0.3, green: 0.9, blue: 0.3))
                        spiralLayer(at: t, clockwise: true, speed: 15, scale: 0.65, color: Color(red: 0.0, green: 0.5, blue: 0.0))

                        // ЖИДКИЙ СЛОЙ: Движение клякс и сгустков по эллипсу
                        blobLayer(at: t)
                        
                        // Яркое центральное ядро
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [Color.white.opacity(0.85), Color(red: 0.4, green: 1.0, blue: 0.4).opacity(0.5), .clear],
                                    center: .center, startRadius: 0, endRadius: 65
                                )
                            )
                            .frame(width: 120, height: 180)
                            .blur(radius: 12)
                    }
                    .frame(width: portalWidth, height: portalHeight)
                    // ИСПРАВЛЕНО: Жестко обрезаем все вылетающие кляксы по форме эллипса
                    .clipShape(Ellipse())

                    // ==========================================
                    // 3. СВЕТЯЩАЯСЯ НЕОНОВАЯ ОБВОДКА (КАНТ ПОРТАЛА)
                    // ==========================================
                    // Салатовое внешнее свечение
                    Ellipse()
                        .stroke(Color(red: 0.5, green: 1.0, blue: 0.5).opacity(0.85), lineWidth: 6)
                        .frame(width: portalWidth + 2, height: portalHeight + 2)
                        .blur(radius: 4)
                    
                    // Плотная белая линия по самому краю
                    Ellipse()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: portalWidth, height: portalHeight)
                        .blur(radius: 0.3)
                }
                // ИСПРАВЛЕНО: Центрируем всю конструкцию, чтобы она не съезжала на экране телефона
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear(perform: generateBlobs)
    }

    // Рисует спиральные завихрения
    private func spiralLayer(at t: TimeInterval, clockwise: Bool, speed: Double, scale: CGFloat, color: Color) -> some View {
        Ellipse()
            .fill(
                AngularGradient(
                    colors: [.clear, color.opacity(0.6), .clear, color.opacity(0.4), .clear],
                    center: .center
                )
            )
            .frame(width: portalWidth * scale, height: portalHeight * scale)
            .rotationEffect(.degrees(t * speed * (clockwise ? 1 : -1)))
            .blur(radius: 15)
            .blendMode(.plusLighter)
    }

    // Рендеринг "жидких" клякс
    private func blobLayer(at t: TimeInterval) -> some View {
        ForEach(blobs) { blob in
            let currentAngle = blob.angle + (t * blob.rotationSpeed)
            let pulse = sin(t * blob.waveSpeed + blob.phase) * 0.08
            let rFraction = blob.radiusFraction + pulse
            
            let posX = cos(currentAngle) * (portalWidth / 2) * rFraction
            let posY = sin(currentAngle) * (portalHeight / 2) * rFraction

            Ellipse()
                .fill(blob.color)
                .frame(width: blob.size.width, height: blob.size.height)
                .rotationEffect(.radians(currentAngle + .pi/2))
                .offset(x: posX, y: posY)
                .blur(radius: blob.color == .white ? 0.8 : 3.5)
        }
    }

    // Генерируем палитру клякс
    private func generateBlobs() {
        var newBlobs: [PortalBlob] = []
        
        let colors = [
            Color(red: 0.4, green: 0.95, blue: 0.2), // Ядовито-кислотный
            Color(red: 0.6, green: 1.0, blue: 0.5),  // Светло-зеленый блик
            Color(red: 0.02, green: 0.25, blue: 0.02), // Глубокий темно-зеленый
            Color.white
        ]
        
        for _ in 0..<38 {
            let color = colors.randomElement()!
            let isWhite = color == .white
            
            newBlobs.append(
                PortalBlob(
                    radiusFraction: CGFloat.random(in: 0.15...0.85),
                    angle: Double.random(in: 0...(2 * .pi)),
                    size: isWhite ?
                        CGSize(width: CGFloat.random(in: 6...12), height: CGFloat.random(in: 6...12)) :
                        CGSize(width: CGFloat.random(in: 35...65), height: CGFloat.random(in: 14...24)), // Кляксы стали чуть жирнее
                    color: color.opacity(isWhite ? Double.random(in: 0.75...0.95) : Double.random(in: 0.45...0.75)),
                    rotationSpeed: Double.random(in: 0.4...1.2), // Крутятся теперь чуток бодрее
                    waveSpeed: Double.random(in: 1.2...3.2),
                    phase: Double.random(in: 0...10)
                )
            )
        }
        
        self.blobs = newBlobs
    }
}

// Модификатор для использования в качестве бэкграунда в OnboardingView
struct PortalBackgroundModifier: ViewModifier {
    var opacity: Double
    func body(content: Content) -> some View {
        ZStack {
            PortalBackground()
                .opacity(opacity)
            content
        }
    }
}

extension View {
    func portalBackground(opacity: Double = 1.0) -> some View {
        modifier(PortalBackgroundModifier(opacity: opacity))
    }
}

#Preview {
    PortalBackground()
}
