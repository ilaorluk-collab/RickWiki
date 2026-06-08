import SwiftUI

@main
struct RickWikiApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .tint(.green)
        }
    }
}
