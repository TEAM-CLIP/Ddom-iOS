//
//  CustomToast.swift
//  ddom
//
//  Created by 김 형석 on 9/20/24.
//

import SwiftUI
import Foundation

struct CustomToast: View {
    let toastData: ToastData
    
    var body: some View {
        HStack{
            Text(toastData.type.text)
                .font(.body5)
                .foregroundStyle(.white)
            
            Spacer()
            
            if let action = toastData.action {
                Button(action: action ) {
                    Text(toastData.type.button)
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

#Preview("Toast") {
    CustomToast_Preview()
}

struct CustomToast_Preview: View {
    @State private var showPopup = false

    var body: some View {
        CustomToast(toastData: ToastData(type: .storeRegistered, action: {print("heeloo")}))
        Spacer()
        CustomToast(toastData: ToastData(type: .storeDeleted("테스트 가게"), action: {print("deleted")}))
    }
}
