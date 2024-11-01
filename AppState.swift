import Foundation

class AppState: ObservableObject {
    static let shared = AppState() // 전역적으로 접근 가능한 인스턴스 생성. 이는 싱글톤으로 구현되어있는 APIManager에서 appState를 직접 접근하게 하기 위해서임.
    @Published var isLoggedIn: Bool = false // Published 래퍼를 통해 상태 변화를 SwiftUI 뷰에 자동반영
    @Published var isGuestMode: Bool = false
    @Published var currentToast: ToastType?
    
    private init() {}
}
