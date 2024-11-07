import Foundation

// 환경 객체용 -> 앱 종료되면 초기화되어도 괜찮은 데이터 보관
class AppState: ObservableObject {
    @Published var currentToast: ToastType?
    @Published var isGuestMode: Bool = false
//    @Published var currentPopup: Popup?
    
    init() {}
}
 
