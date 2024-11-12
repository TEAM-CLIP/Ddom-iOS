import Foundation
import SwiftUI
import Combine

// 환경 객체용 -> 앱 종료되면 초기화되어도 괜찮은 데이터 보관
class AppState: ObservableObject {
    @Published var isLoggedIn = UserDefaultsManager.shared.isLoggedIn
    @Published private(set) var currentPopup: PopupData?
    @Published var currentToast: ToastData?
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
    
    func showPopup(type: PopupType, action: @escaping () -> Void) {
        currentPopup = PopupData(type: type, action: action)
    }
    
    func removePopup(){
        //MARK: currentPopup이 nil이되면, 바로 ContentView에서 제거되기 때문에, interpolate 불가 -> withAnimation 효과 없음
        currentPopup = nil
    }
}
 
