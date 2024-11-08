//
//  CustomToast.swift
//  ddom
//
//  Created by 김 형석 on 9/20/24.
//

import SwiftUI
import Foundation

struct CustomToast: View {
    let toastData: ToastType
    
    var body: some View {
        HStack{
            Text(toastData.text)
                .font(.body5)
                .foregroundStyle(.white)
            
            Spacer()
            
            if let buttonData = toastData.button {
                Button(action: buttonData.action ) {
                    Text(buttonData.label)
                        .fontStyle(.body5)
                        .foregroundStyle(.secondary6)
                }
                .padding(.horizontal,6)
            }
        }
        .padding(.vertical,14)
        .padding(.horizontal,18)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(.black.opacity(0.7)))
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
        
        .padding(16)
    }
}

#Preview("Popup") {
    CustomPopupOneBtn_Preview()
}

struct CustomPopupOneBtn_Preview: View {
    @State private var showPopup = false

    var body: some View {
        CustomToast(toastData: .storeRegistered(action: {print("heeloo")}))
        Spacer()
        CustomToast(toastData: .storeDeleted(name: "스타벅스 이대", action: {print("heeloo")}))
    }
}
