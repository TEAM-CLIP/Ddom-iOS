import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct DdomApp: App {
    @StateObject private var appState = AppState.shared
    
    init() {
        KakaoSDK.initSDK(appKey: "4200bb2006c1e166c3fbb5783d9c6a89")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
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
