import SwiftUI

struct CustomPopupOneBtn: View {
    @Binding var isShowing: Bool
    
    let title: String
    let message: String?
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(spacing:6){
                    Text(title)
                        .fontStyle(.body3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray9)
                    
                    if let message = message {
                        Text(message)
                            .fontStyle(.caption1)
                            .foregroundColor(.gray5)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical,20)
                
                VStack(spacing: 4) {
                    Button(action: {
                        action()
                        withAnimation(.fastEaseOut) { isShowing = false }
                    }) {
                        Text(buttonTitle)
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
            .padding(.horizontal,12)
            .padding(.vertical,8)
            .background(RoundedRectangle(cornerRadius:20)
                .fill(.white))
            .padding(.horizontal, 44)
        }
    }
}
