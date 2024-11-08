import SwiftUI

struct CustomPopup: View {
    @Binding var isShowing: Bool
    let popupData: PopupType
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(spacing:6){
                    if let storeName = popupData.storeName {
                        VStack(spacing:4){
                            HStack(spacing:0){
                                Text(storeName)
                                    .fontStyle(.body3)
                                Text("를")
                                    .fontStyle(.body4)
                            }
                            Text(popupData.title)
                                .fontStyle(.body4)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.gray10)
                    } else {
                        Text(popupData.title)
                            .fontStyle(.body3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray10)
                    }
                    
                    if let description = popupData.description {
                        Text(description)
                            .fontStyle(.caption1)
                            .foregroundColor(.gray5)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical,20)
                
                if popupData.isBtnHorizontal {
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
    }
    
    // MARK: - 하단 버튼 레이어
    private var verticalButtonLayer: some View {
        VStack(spacing: 4) {
            Button(action: {
                popupData.primaryButton.action()
                withAnimation(.fastEaseOut) { isShowing = false }
            }) {
                Text(popupData.primaryButton.label)
                    .frame(maxWidth: .infinity)
                    .fontStyle(.body5)
                    .padding(.vertical, 9)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(.gray10)
                    )
            }
            
            Button(action: {
                withAnimation(.fastEaseOut) { isShowing = false }
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
                withAnimation(.fastEaseOut) { isShowing = false }
            }) {
                Text(popupData.secondaryButtonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(.gray10)
                    .cornerRadius(8)
            }
            
            Button(action: {
                popupData.primaryButton.action()
                withAnimation(.fastEaseOut) { isShowing = false }
            }) {
                Text(popupData.primaryButton.label)
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
//    CustomPopupOneBtn_Preview()
//}
//
//struct CustomPopupOneBtn_Preview: View {
//    @State private var showPopup = false
//
//    var body: some View {
//        CustomPopup(isShowing: $showPopup, popupData: .storeRegister(name: "이대", action: {print("heeloo")}))
//        CustomPopup(isShowing: $showPopup, popupData: .login(action: {print("heeloo")}))
//        CustomPopup(isShowing: $showPopup, popupData: .storeDelete(name: "이대",action: {print("heeloo")}))
//        CustomPopup(isShowing: $showPopup, popupData: .storeFull(action: {print("heeloo")}))
//    }
//}
