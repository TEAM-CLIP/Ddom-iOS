import SwiftUI

struct CustomPopupTwoBtn: View {
    @Binding var isShowing: Bool
    
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 4) {
                Text(title)
                    .fontStyle(.heading2)
                    .foregroundColor(.gray9)
                    .padding(.top,12)
                
                Text(message)
                    .fontStyle(.body3)
                    .foregroundColor(.gray5)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height:12)
                
                HStack(spacing: 8) {
                    Button(action: {
                        secondaryAction()
                        withAnimation (.fastEaseOut) { isShowing = false }
                    }) {
                        Text(secondaryButtonTitle)
                            .frame(maxWidth: .infinity)
                            .fontStyle(.body1)
                            .padding()
                            .background(.gray2)
                            .foregroundColor(.gray6)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        primaryAction()
                        withAnimation (.fastEaseOut) { isShowing = false }
                    }) {
                        Text(primaryButtonTitle)
                            .frame(maxWidth: .infinity)
                            .fontStyle(.body1)
                            .padding()
                            .background(.primary9)
                            .foregroundStyle(.myWhite)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(.myWhite)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }
}
