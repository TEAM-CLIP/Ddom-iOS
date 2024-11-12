import SwiftUI

struct CustomPopup: View {
    let hidePopup: () -> Void
    let popupData: PopupData
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing:6){
                Text(popupData.type.title)
                    .fontStyle(.body3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray10)
                
                
                if let description = popupData.type.description {
                    Text(description)
                        .fontStyle(.caption1)
                        .foregroundColor(.gray5)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical,20)
            
            if popupData.type.isBtnHorizontal {
                horizontalButtonLayer
            } else {
                verticalButtonLayer
            }
        }
        .padding(.horizontal,12)
        .padding(.vertical,8)
        .background(RoundedRectangle(cornerRadius:20)
            .fill(.white)
        )
        .padding(.horizontal, 44)
    }
    
    
    // MARK: - 하단 버튼 레이어
    private var verticalButtonLayer: some View {
        VStack(spacing: 4) {
            Button(action: {
                popupData.action()
                hidePopup()
            }) {
                Text(popupData.type.primaryButtonText)
                    .frame(maxWidth: .infinity)
                    .fontStyle(.body5)
                    .padding(.vertical, 9)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(.gray10)
                    )
            }
            
            Button(action: {
                hidePopup()
            }) {
                Text("닫기")
                    .fontStyle(.caption1)
                    .foregroundStyle(.gray5)
            }
            .padding(8)
        }
    }
    
    private var horizontalButtonLayer: some View {
        HStack(spacing: 8) {
            Button(action: {
                hidePopup()
            }) {
                Text(popupData.type.secondaryButtonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(.gray10)
                    .cornerRadius(8)
            }
            
            Button(action: {
                popupData.action()
                hidePopup()
            }) {
                Text(popupData.type.primaryButtonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(.gray10)
                    .cornerRadius(8)
            }
        }
        .fontStyle(.body5)
        .foregroundStyle(.white)
    }
}

//#Preview("Popup") {
//    CustomPopup_Preview()
//}
//
//struct CustomPopup_Preview: View {
//    @State private var showPopup = true
//
//    var body: some View {
//        CustomPopup(isShowing: $showPopup, popupData: PopupData(type:.storeRegister("이대"),action:{print("storeRegister")}))
//        CustomPopup(isShowing: $showPopup, popupData: PopupData(type:.storeDelete("이대"),action:{print("storeDelete")}))
//        CustomPopup(isShowing: $showPopup, popupData: PopupData(type:.login,action:{print("login")}))
//        CustomPopup(isShowing: $showPopup, popupData: PopupData(type:.storeFull,action:{print("storeFull")}))
//    }
//}
