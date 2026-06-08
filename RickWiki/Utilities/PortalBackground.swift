import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let speed: Double
    let drift: Double
    let phase: Double
    let glow: Bool
}

struct PortalBackground: View {
    @State private var particles: [Particle] = []

    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.02, blue: 0.08)

            TimelineView(.animation) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    outerGlow(at: t)
                    midRing(at: t)
                    innerRing(at: t)
                    centerGlow
                    particleLayer(at: t)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: generateParticles)
    }

    private func outerGlow(at t: TimeInterval) -> some View {
        Circle()
            .fill(
                AngularGradient(
                    colors: [
                        .clear,
                        .green.opacity(0.25),
                        .clear,
                        Color(red: 0.2, green: 0.9, blue: 0.2).opacity(0.15),
                        .clear,
                    ],
                    center: .center
                )
            )
            .frame(width: 360, height: 360)
            .rotationEffect(.degrees(t * 18))
            .blur(radius: 50)
    }

    private func midRing(at t: TimeInterval) -> some View {
        Circle()
            .stroke(
                AngularGradient(
                    colors: [
                        .clear,
                        Color(red: 0.3, green: 1.0, blue: 0.3).opacity(0.5),
                        .clear,
                        Color(red: 0.1, green: 0.7, blue: 0.1).opacity(0.35),
                        .clear,
                    ],
                    center: .center
                ),
                lineWidth: 2.5
            )
            .frame(width: 240, height: 240)
            .rotationEffect(.degrees(t * -28))
            .blur(radius: 3)
    }

    private func innerRing(at t: TimeInterval) -> some View {
        Circle()
            .stroke(
                AngularGradient(
                    colors: [
                        .clear,
                        Color(red: 0.4, green: 1.0, blue: 0.4).opacity(0.6),
                        .clear,
                        Color(red: 0.2, green: 0.8, blue: 0.2).opacity(0.4),
                        .clear,
                    ],
                    center: .center
                ),
                lineWidth: 2
            )
            .frame(width: 160, height: 160)
            .rotationEffect(.degrees(t * 38))
            .blur(radius: 2)
    }

    private var centerGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.4, green: 1.0, blue: 0.4).opacity(0.7),
                        Color(red: 0.1, green: 0.5, blue: 0.1).opacity(0.25),
                        .clear,
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 90
                )
            )
            .frame(width: 100, height: 100)
            .blur(radius: 12)
    }

    private func particleLayer(at t: TimeInterval) -> some View {
        ForEach(particles) { p in
            Circle()
                .fill(Color(red: 0.3, green: 1.0, blue: 0.3))
                .frame(width: p.size, height: p.size)
                .opacity(0.5 + 0.5 * sin(t * p.speed + p.phase))
                .offset(
                    x: p.x + cos(t * p.drift + p.phase) * 15,
                    y: p.y + sin(t * p.drift + p.phase) * 15
                )
                .blur(radius: p.glow ? 4 : 0.5)
        }
    }

    private func generateParticles() {
        particles = (0..<16).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let dist = CGFloat.random(in: 60...170)
            return Particle(
                x: cos(angle) * dist,
                y: sin(angle) * dist,
                size: CGFloat.random(in: 1.5...4),
                speed: Double.random(in: 0.5...2),
                drift: Double.random(in: 0.3...1.2),
                phase: Double.random(in: 0...(2 * .pi)),
                glow: .random()
            )
        }
    }
}

// MARK: - Portal container modifier

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
    func portalBackground(opacity: Double = 0.35) -> some View {
        modifier(PortalBackgroundModifier(opacity: opacity))
    }
}

#Preview {
    PortalBackground()
}
