import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TitleView()
                    .containerRelativeFrame(.vertical)
                    .background(.clear)

                DescriptionView()
                    .containerRelativeFrame(.vertical)
                    .background(.clear)

                HomeView()
                    .containerRelativeFrame(.vertical)
                    .background(.clear)
                    .padding(.top, 300)
            }
            .scrollTargetLayout()
            .background(.clear)
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .background(.clear)
        .portalBackground(opacity: 0.25)
    }
}
