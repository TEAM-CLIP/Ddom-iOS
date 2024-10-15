//
//  CustomVButton.swift
//  tyte
//
//  Created by 김 형석 on 9/25/24.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let isLoading: Bool
    let text: String
    let isDisabled: Bool
    var loadingTint: Color = .gray6
    var enabledBackgroundColor: Color = .gray10
    var disabledBackgroundColor: Color = .gray3
    var enabledForegroundColor: Color = .white
    var disabledForegroundColor: Color = .gray1
    var font: Font = .body3
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .tint(loadingTint)
                    .frame(maxHeight:48)
            } else {
                Text(text)
                    .padding(16)
                    .font(font)
                    .frame(maxHeight:48)
                    .background(isDisabled ? disabledBackgroundColor : enabledBackgroundColor)
                    .foregroundColor(isDisabled ? disabledForegroundColor : enabledForegroundColor)
                    .cornerRadius(cornerRadius)
            }
        }
        .disabled(isDisabled || isLoading)
    }
}
