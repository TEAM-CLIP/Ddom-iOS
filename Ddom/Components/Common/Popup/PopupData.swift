struct PopupData {
    let type: PopupType
    let action: () -> Void
}

enum PopupType: Equatable {
    case storeRegister(String)
    case storeDelete(String)
    case storeFull
    case login
    
    var isBtnHorizontal: Bool {
        switch self {
        case .storeDelete:
            return true
        default:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .storeRegister(let name):
            return "\(name)을(를)\n또옴가게로 등록할까요?"
        case .storeDelete:
            return "또옴가게에서 삭제하시겠습니까?"
        case .storeFull:
            return "또옴가게가 꽉 찼어요"
        case .login:
            return "지금 로그인하면,\n또옴 가게 혜택을 받을 수 있어요"
        }
    }
    
    var description: String? {
        switch self {
        case .storeFull:
            return "변경을 원한다면, 등록된 가게를 삭제해주세요.\n삭제 후 7일이 지나면, 또옴가게를 변경할 수 있어요."
        case .storeDelete:
            return "지금 삭제하시면, 한달동안 추가할 수 없어요"
        default:
            return nil
        }
    }
    
    var primaryButtonText: String {
        switch self {
        case .storeRegister:
            return "가게 등록하기"
        case .storeDelete:
            return "삭제하기"
        case .storeFull:
            return "가게 수정하기"
        case .login:
            return "로그인하러 가기"
        }
    }
    
    var secondaryButtonText: String {
        switch self {
        case .storeDelete:
            return "취소하기"
        default:
            return "닫기"
        }
    }
}
