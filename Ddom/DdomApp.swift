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
    @State private var isPopupPresent = false // isPopupPresent 문제임 이건 ㅇㅇ
    
    var body: some View {
        ZStack {
            if appState.isLoggedIn || appState.isGuestMode {
                MainTabView()
            } else {
                OnboardingView()
                    .ignoresSafeArea()
            }
            
            if let popup = appState.currentPopup {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isPopupPresent ? 0.3 : 0.0)
                    .onTapGesture { hidePopup() }
                    .animation(.spring(duration:0.1),value:isPopupPresent)
                
                CustomPopup(hidePopup:hidePopup, popupData: popup)
                    .opacity(isPopupPresent ? 1 : 0)
                    .offset(y: isPopupPresent ? 0 : -80)
                    .animation(.spring(duration:0.3),value:isPopupPresent)
            }
            
            if let toast = appState.currentToast {
                CustomToast(toastData: toast)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 40)
                    .zIndex(1)
                    .opacity(isToastPresent ? 1 : 0)
                    .offset(y: isToastPresent ? 0 : -80)
                    .animation(.spring(duration:0.5),value:isToastPresent)
            }
        }
        .onChange(of: appState.currentToast?.type) { _, newToast in
            handleToastChange(newToast,in: 3.0)
        }
        .onChange(of: appState.currentPopup?.type) { _, newPopup in
            handlePopupChange(newPopup)
        }
    }
    
    
    private func handlePopupChange(_ newPopup:PopupType?){
        if newPopup != nil { isPopupPresent = true }
    }
    
    private func hidePopup(){
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            appState.removePopup()
        }
    }
    
    private func handleToastChange(_ newToast: ToastType?, in interval:Double) {
        if newToast != nil {
            isToastPresent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                isToastPresent = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appState.currentToast = nil
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
