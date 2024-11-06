//
//  DetailView.swift
//  Ddom
//
//  Created by Neoself on 11/5/24.
//

import SwiftUI

struct TermsDetailBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CreateAccountViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(.gray2)
                    .frame(width: 56, height: 8)
                    .padding(16)

            
            ScrollView {
                VStack(alignment: .leading, spacing:0) {
                    Text("또옴과 함께하려면,")
                        .fontStyle(.title1)
                        .foregroundStyle(.gray10)
                        .padding(.bottom,8)
                    
                    Text("가입 및 정보 제공에 동의하지 않으면,\n일부 기능이 제한될 수 있어요.")
                        .fontStyle(.body5)
                        .foregroundStyle(.gray5)
                        .padding(.bottom,24)
                    
                    Button(action: {
                        viewModel.toggleAllChecks()
                    }) {
                        HStack(spacing: 6){
                            Image("check")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(viewModel.isAllChecked ? .secondary6 :.gray3)
                                .frame(width: 24, height: 24)
                            
                            Text("모두 동의하기")
                                .fontStyle(.body3)
                                .foregroundStyle(viewModel.isAllChecked ? .gray10 : .gray3)
                        }
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius:8)
                            .fill(viewModel.isAllChecked ? .gray1 : .surface1)
                        )
                    }
                    .padding(.bottom, 8)
                    
                    VStack(spacing:4){
                        checkItem(isChecked:$viewModel.isServiceChecked,
                                  description: "[필수] 서비스 이용약관"
                        ){
                            print("onFirstPress")
                        }
                        checkItem(isChecked:$viewModel.isPrivacyChecked,
                                  description: "[필수] 개인정보 수집/이용 동의"
                        ){
                            print("onSecondPress")
                        }
                        checkItem(isChecked:$viewModel.isAdvertisementChecked,
                                  description: "[선택] 맞춤형 광고 및 개인정보 제공 동의"
                        ){
                            print("onThirdPress")
                        }
                        checkItem(isChecked:$viewModel.isMarketingChecked,
                                  description: "[선택] 마케팅 수신 동의"
                        ){
                            print("onFourthPress")
                        }
                        
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                }
            }
            .padding(.top,16)
            
            CustomButton(action: {viewModel.handleSubmit()},
                         isPrimary: false,
                         isLoading: false,
                         text: "동의하고 가입하기",
                         isDisabled: viewModel.isAgreeButtonDisabled,
                         isFullWidth: true
            )
        }
        .padding(.horizontal,16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

@ViewBuilder
private func checkItem(isChecked: Binding<Bool>, description: String, onPress: @escaping () -> Void) -> some View {
    HStack(spacing: 0) {
        HStack(spacing:8) {
            Image("check")
                .renderingMode(.template)
                .foregroundStyle(isChecked.wrappedValue ? .secondary6 : .gray3)
            
            Text(description)
                .fontStyle(.body4)
                .foregroundStyle(.gray10)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture {
            isChecked.wrappedValue.toggle()
        }
        
        Spacer()
        
        Text("보기")
            .fontStyle(.caption1)
            .foregroundStyle(.gray3)
            .onTapGesture(perform: onPress)
    }
    .padding(8)
}
