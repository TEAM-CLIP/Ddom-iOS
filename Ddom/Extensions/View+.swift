import SwiftUI

extension View {
    func fontStyle(_ font: Font) -> some View {
        self.font(font)
            .kerning(CGFloat(font.letterSpacing))
            .lineSpacing(CGFloat(font.lineSpacing/2))
    }
    
    func attributedText(_ searchText: String, color: Color) -> some View {
        self.overlay(
            Text(self.asString())
                .fontStyle(.body4)
                .foregroundStyle(color)
                .mask(
                    HStack(spacing: 0) {
                        ForEach(self.asString().ranges(of: searchText), id: \.self) { range in
                            Text(String(self.asString()[range]))
                        }
                    }
                )
        )
    }
    
    private func asString() -> String {
        if let text = (self as? Text)?.asString() {
            return text
        }
        return ""
    }
}
