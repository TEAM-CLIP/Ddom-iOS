//
//  CustomVButton.swift
//  tyte
//
//  Created by 김 형석 on 9/25/24.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let isPrimary: Bool
    let isLoading: Bool
    let text: String
    let isDisabled: Bool
    var loadingTint: Color = .gray6
    var font: Font = .body5
    var cornerRadius: CGFloat = 8
    var iconName: String?
    var isFullWidth: Bool
    
    private var enabledBgColor: Color {
        isPrimary ? .primary6 : .gray10
    }
    private var disabledBgColor: Color {
        isPrimary ? .primary4 : .gray3
    }
    private var enabledFgColor: Color {
        isPrimary ? .gray10 : .white
    }
    private var disabledFgColor: Color {
        isPrimary ? .primary8 : .gray1
    }
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .tint(loadingTint)
                    .frame(maxWidth: isFullWidth ? .infinity : .none, maxHeight:48,alignment: .center)
            } else {
                HStack(spacing:8){
                    if(iconName != nil){
                        Image(iconName!)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 16,height:16)
                            .foregroundStyle(.white)
                    }
                    
                    Text(text)
                        .font(font)
                    
                }
                .padding(13)
                .frame(maxWidth: isFullWidth ? .infinity : .none, maxHeight:48)
                .background(isDisabled ? disabledBgColor : enabledBgColor)
                .foregroundColor(isDisabled ? disabledFgColor : enabledFgColor)
                .cornerRadius(cornerRadius)
            }
        }
        .disabled(isDisabled || isLoading)
    }
}
