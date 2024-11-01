import SwiftUI

struct CustomPopupOneBtn: View {
    @Binding var isShowing: Bool
    
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing:0){
                Button(action: {
                    withAnimation (.fastEaseOut) { isShowing = false }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding(8)
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                
                Text(title)
                    .fontStyle(.heading1)
                    .foregroundColor(.gray9)
                    .padding(.top, -16)
                    .padding(.bottom, 6)
                
                Text(message)
                    .fontStyle(.body3)
                    .foregroundColor(.gray5)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height:20)
                
                Button(action: {
                    primaryAction()
                    withAnimation (.fastEaseOut) { isShowing = false }
                }) {
                    Text(primaryButtonTitle)
                        .frame(maxWidth: .infinity)
                        .fontStyle(.title1)
                        .padding()
                        .background(isDisabled ? .gray5 : .primary8)
                        .foregroundStyle(isDisabled ? .gray6 : .gray1)
                        .cornerRadius(8)
                }
                .disabled(isDisabled)
                
                
            }
            .padding(12)
            .background{
                RoundedRectangle(cornerRadius: 16).fill(.gray1)
                    .shadow(radius: 10)
            }
            .padding(.horizontal, 40)
        }
    }
}
