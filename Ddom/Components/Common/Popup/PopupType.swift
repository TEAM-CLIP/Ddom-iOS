enum PopupType {
    case storeRegister(name:String, action:(()-> Void))
    case storeDelete(name:String, action:(()-> Void))
    case storeFull(action:(()-> Void))
    case login(action:(()-> Void))
    
    var isBtnHorizontal:Bool {
        switch self {
        case .storeDelete:
            true
        default:
            false
        }
    }
    
    var storeName:String? {
        switch self{
        case .storeRegister(let name,_):
            name
        case .storeDelete(let name,_):
            name
        default:
            nil
        }
    }
    
    var title: String {
        switch self {
        case .storeRegister:
            "또옴가게로 등록할까요?"
        case .storeDelete:
            "또옴가게에서 삭제하시겠습니까?"
        case .storeFull:
            "또옴가게가 꽉 찼어요"
        case .login:
            "지금 로그인하면,\n또옴 가게 혜택을 받을 수 있어요"
        }
    }
    
    var description: String? {
        switch self {
        case .storeFull:
            "변경을 원한다면, 등록된 가게를 삭제해주세요.\n삭제 후 7일이 지나면, 또옴가게를 변경할 수 있어요."
        case .storeDelete:
            "지금 삭제하시면, 한달동안 추가할 수 없어요"
        default:
            nil
        }
    }
    
    var secondaryButtonText: String {
        switch self{
        case .storeDelete:
            "취소하기"
        default:
            "hello"
        }
    }
    
    var primaryButton: (action:(()-> Void),label:String) {
        switch self {
        case .storeRegister(_, let action):
            (action:action,label:"가게 등록하기")
        case .storeDelete(_, let action):
            (action:action,label:"삭제하기")
        case .storeFull(let action):
            (action:action,label:"가게 수정하기")
        case .login(let action):
            (action:action,label:"로그인하러 가기")
        }
    }
}
