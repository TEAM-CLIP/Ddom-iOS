import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct DdomApp: App {
    @StateObject private var appState = AppState()
    
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
    @State private var isToastPresent = false
    @State private var isPopupPresent = false
    
    var body: some View {
        ZStack {
            if appState.isLoggedIn || appState.isGuestMode {
                MainTabView()
            } else {
                OnboardingView()
                    .ignoresSafeArea()
            }
            
            if isToastPresent, let toast = appState.currentToast {
                CustomToast(toastData: toast)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 40)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .move(edge: .top))
                    ))
                    .animation(.mediumEaseInOut, value: isToastPresent)
            }
            
            if isPopupPresent, let popup = appState.currentPopup {
                CustomPopup(isShowing:$isPopupPresent, popupData: popup)
            }
        }
        .onChange(of: appState.currentToast?.text) { _, newValue in
            if newValue != nil {
                withAnimation {
                    isToastPresent = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isToastPresent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appState.currentToast = nil
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
