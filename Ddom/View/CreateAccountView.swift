//
//  CreateAccountView.swift
//  Ddom
//
//  Created by 김 형석 on 10/15/24.
//

import SwiftUI

struct CreateAccountView: View {
    @StateObject var viewModel = CreateAccountViewModel()
    @FocusState private var focusedField: Field?
    
    @Environment(\.presentationMode) var presentationMode
    
    enum Field: Hashable {
        case username
        case phone
    }
    
    var body: some View {
        ZStack{
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
            
            VStack{
                BackNavBar()
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        HStack(spacing: 0){
                            Text("회원가입")
                                .fontStyle(.heading2)
                                .foregroundStyle(.secondary6)
                            Text("을 위해")
                                .fontStyle(.heading2)
                                .foregroundStyle(.gray10)
                        }
                        
                        Text("간단한 정보를 알려주세요")
                            .fontStyle(.heading2)
                            .foregroundStyle(.gray10)
                    }
                    .padding(.vertical,24)
                    
                    VStack(alignment: .leading){
                        HStack(spacing:2){
                            Text("닉네임")
                                .fontStyle(.body3)
                                .foregroundStyle(.gray10)
                            
                            Text("*")
                                .fontStyle(.body3)
                                .foregroundStyle(Color(hex:"ff6f6f"))
                            
                            Spacer()
                        }
                        
                        HStack(spacing:10){
                            CustomTextField(
                                text: $viewModel.username,
                                placeholder: "닉네임을 입력해주세요",
                                keyboardType: .default,
                                onSubmit: {print("username") },
                                isError: !viewModel.errorText.isEmpty
                            )
                            .focused($focusedField, equals: .username)
                            
                            CustomButton(
                                action:{ viewModel.handleDuplicateCheckButton() },
                                isPrimary: false,
                                isLoading: false,
                                text: "중복확인",
                                isDisabled: viewModel.username.isEmpty || viewModel.isUsernameValid,
                                isFullWidth: false
                            )
                        }
                        
                        statusText(viewModel: viewModel)
                    }
                    .padding(.bottom,32)
                    
                    HStack(spacing:2){
                        Text("휴대폰 번호")
                            .fontStyle(.body3)
                            .foregroundStyle(.gray10)
                        Text("*")
                            .fontStyle(.body3)
                            .foregroundStyle(Color(hex:"ff6f6f"))
                        
                        Spacer()
                    }
                    
                    CustomTextField(
                        text: $viewModel.phone,
                        placeholder: "000-0000-0000",
                        keyboardType: .numberPad,
                        onSubmit: {print("number") }
                    )
                    .frame(maxWidth: .infinity)
                    .focused($focusedField, equals: .phone)
                    
                    Spacer()
                    
                    CustomButton(
                        action: {print("submit")},
                        isPrimary: false,
                        isLoading: false,
                        text: "입력하기",
                        isDisabled: viewModel.isSignUpButtonDisabled,
                        isFullWidth: true)
                    
                }
                .padding(.horizontal,16)
            }
        }
        .onAppear{
            focusedField = Field.username
        }
        .toolbar(.hidden)
    }
}

@ViewBuilder
private func statusText(viewModel:CreateAccountViewModel) -> some View {
    if viewModel.errorText.isEmpty {
        if viewModel.isUsernameValid {
            HStack(spacing:4){
                Image("check")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width:16,height:16)
                    .foregroundStyle(.success)
                
                Text("중복확인이 완료 되었습니다")
                    .fontStyle(.caption1)
                    .foregroundStyle(.success)
            }
            .padding(.leading,12)
        } else {
            Text("최소 2자~8자 (영문,국문 가능)")
                .fontStyle(.caption1)
                .foregroundStyle(.gray5)
                .padding(.leading,12)
        }
    } else {
        Text(viewModel.errorText)
            .fontStyle(.caption1)
            .foregroundStyle(.error)
            .padding(.leading,12)
    }
}

#Preview {
    CreateAccountView()
}

