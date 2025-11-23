import SwiftUI

@main
struct CareerFairLoginApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.currentScreen {
                case .login:
                    LoginView()
                case .onboarding:
                    OnboardingView()
                case .home:
                    HomeView()
                }
            }
            .environmentObject(appState)
        }
    }
}

