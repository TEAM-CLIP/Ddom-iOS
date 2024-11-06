//  OnboardingView.swift
//  Ddom
//  Created by 김 형석 on 10/15/24.

import SwiftUI
import UIKit
import AuthenticationServices

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                Spacer().frame(height:56)
                VStack(alignment: .leading, spacing: 2) {
                    Text("또 오고싶은 가게라면?")
                        .fontStyle(.heading1)
                        .foregroundStyle(.gray10)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text("또옴 가게를 등록하고 혜택을 받아보세요!")
                        .fontStyle(.body2)
                        .foregroundStyle(.gray5)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                TabView {
                    ForEach(0..<3) { index in
                        SwipeableContentView(index: index)
                    }
                }
                .tint(.gray7)
                .foregroundStyle(.gray7)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .padding(.horizontal, 16)
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: {
                        viewModel.performKakaoLogin()
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Kakao로 로그인하기")
                        }
                        .fontStyle(.body5)
                        .foregroundStyle(.gray10)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex:"FAE300"))
                        .cornerRadius(8)
                    }
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName,.email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                viewModel.performAppleLogin(authResults)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    )
                    .frame(height: 50)
                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(.gray60, lineWidth: 1)
//                    )
                    
                    Button(action: {
                        viewModel.moveToMainTabView()
                    }) {
                        Text("로그인 없이 사용하기")
                            .fontStyle(.caption)
                            .foregroundStyle(.gray4)
                            .padding(.top,8)
                            .padding(.bottom,16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{setupAppearance()}
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .createAccount:
                    CreateAccountView()
                default:
                    CreateAccountView()
                }
            }
        }
    }
}

func setupAppearance() {
    UIPageControl.appearance().currentPageIndicatorTintColor = .gray2
    UIPageControl.appearance().pageIndicatorTintColor = .gray1
}

struct SwipeableContentView: View {
    let index: Int
    
    var body: some View {
        VStack {
            Text("스와이프 가능한 콘텐츠 \(index + 1)")
                .fontStyle(.heading1)
                .foregroundColor(.gray2)
        }
        .frame(maxWidth: .infinity, maxHeight: 389)
        .background(.surface1)
        .cornerRadius(16)
    }
}

#Preview {
    OnboardingView()
}
