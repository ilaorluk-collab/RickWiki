import SwiftUI

struct DescriptionView: View {
    @State private var hasAppeared = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "person.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .scaleEffect(hasAppeared ? 1 : 0.7)
                    .opacity(hasAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: hasAppeared)

                Text("RickWiki — твой гид по вселенной Рика и Морти.\nПерсонажи, локации, эпизоды.\nВся информация под рукой.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .scaleEffect(hasAppeared ? 1 : 0.7)
                    .opacity(hasAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: hasAppeared)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear { hasAppeared = true }
    }

}
