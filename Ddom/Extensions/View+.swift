import SwiftUI

extension View {
    func fontStyle(_ font: Font) -> some View {
        self.font(font)
            .lineSpacing(CGFloat(font.lineSpacing))
            .kerning(CGFloat(font.letterSpacing))
    }
}
