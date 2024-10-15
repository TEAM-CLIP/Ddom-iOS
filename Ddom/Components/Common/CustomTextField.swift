import SwiftUI
// 제너릭 타입 매개변수 선언.
struct CustomTextField<T>: View where T: Hashable {
    @Binding var text: T
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var onSubmit: (() -> Void)?
    var textColor: Color = .gray10
    var placeholderColor: Color = .gray3
    var backgroundColor: Color = .surface1
    var borderColor: Color = .gray3
    
    var body: some View {
        TextField("",
                  text: Binding(
                    get: { String(describing: text) },
                    set: { if let value = $0 as? T { text = value } }
                  ),
                  prompt: Text(placeholder).foregroundColor(placeholderColor)
        )
        .fontStyle(.body2)
        .foregroundColor(textColor)
        .padding(.horizontal,12)
        .frame(maxHeight: 48)
        .background(RoundedRectangle(cornerRadius: 8).fill(backgroundColor))
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(borderColor, lineWidth: 1)
//        )
        .autocapitalization(.none)
        .keyboardType(keyboardType)
        .onSubmit {
            onSubmit?()
        }
    }
}
