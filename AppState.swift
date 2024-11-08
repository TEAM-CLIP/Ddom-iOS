import Foundation
import Combine

// 환경 객체용 -> 앱 종료되면 초기화되어도 괜찮은 데이터 보관
class AppState: ObservableObject {
    @Published var isLoggedIn = UserDefaultsManager.shared.isLoggedIn
    @Published var currentToast: ToastType?
    @Published var currentPopup: PopupType?
    @Published var isGuestMode: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        UserDefaultsManager.shared.isLoggedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.isLoggedIn = newValue
            }
            .store(in: &cancellables)
    }
}
 
