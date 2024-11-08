enum ToastType {
    case storeRegistered(action:(()-> Void))
    case storeDeleted(name:String, action:(()-> Void))
    case error(String)
    
    var text: String{
        switch self {
        case .storeRegistered:
            "나의 또옴 가게로 등록되었어요"
        case .storeDeleted(let name, _):
            "'\(name)'이(가) 삭제되었어요"
        case .error(let message):
            message
        }
    }
    
    var button: (action:(()-> Void),label:String)? {
        switch self {
        case .storeRegistered(let action):
            (action:action,label:"보기")
        default:
            nil
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
