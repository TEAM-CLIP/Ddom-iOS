//
//  CreateAccountView.swift
//  Ddom
//
//  Created by 김 형석 on 10/15/24.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email:String = ""
    @State private var phone:String = ""
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email
        case phone
        case username
    }
    
    var body: some View {
        ZStack{
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
            
            VStack{
                HStack(spacing:10){
                    CustomTextField(
                        text: $email,
                        placeholder: "닉네임을 입력해주세요",
                        keyboardType: .default,
                        onSubmit: {print("email") }
                    )
                    .frame(maxWidth: .infinity)
                    .focused($focusedField, equals: .username)
                    
                    CustomButton(
                        action: {print("heello")},
                        isLoading: false,
                        text: "중복확인",
                        isDisabled: email.isEmpty
                    )
                }
                CustomTextField(
                    text: $phone,
                    placeholder: "000-0000-0000",
                    keyboardType: .numberPad,
                    onSubmit: {print("number") }
                )
                .frame(maxWidth: .infinity)
                .focused($focusedField, equals: .phone)
            }
            .padding(.horizontal,16)
        }
    }
}

#Preview {
    CreateAccountView()
}
