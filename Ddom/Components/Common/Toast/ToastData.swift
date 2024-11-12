struct ToastData {
    let type: ToastType
    let action: (() -> Void)?
}

enum ToastType:Equatable {
    case storeRegistered
    case storeDeleted(String)
    case error(String)
    
    var text: String{
        switch self {
        case .storeRegistered:
            "나의 또옴 가게로 등록되었어요"
        case .storeDeleted(let name):
            "'\(name)'이(가) 삭제되었어요"
        case .error(let message):
            message
        }
    }
    
    var button: String {
        switch self {
        case .storeRegistered:
            "보기"
        default:
            "버튼"
        }
    }
//    var icon: String {
//        switch self {
//        case .error:
//            "exclamationmark.circle.fill"
//        default:
//            "checkmark.circle.fill"
//        }
//    }
}
