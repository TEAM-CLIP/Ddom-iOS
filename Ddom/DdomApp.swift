import SwiftUI

@main
struct DdomApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.isLoggedIn || appState.isGuestMode {
            MainTabView()
        } else {
            OnboardingView()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.shared)
}
