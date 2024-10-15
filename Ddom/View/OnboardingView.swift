//
//  OnboardingView.swift
//  Ddom
//
//  Created by 김 형석 on 10/15/24.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height:56)
            VStack(alignment: .leading, spacing: 2) {
                Text("자주가는 가게라면?")
                    .fontStyle(.heading)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                Text("다른 사람보다 쉽게 가격에 이용할 수 있어요!")
                    .fontStyle(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            
            Spacer().frame(height:20)
            
            TabView {
                ForEach(0..<3) { index in
                    SwipeableContentView(index: index)
                }
            }
            .tint(.gray7)
            .foregroundStyle(.gray7)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: {
                    // Kakao 로그인 액션
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Kakao로 로그인")
                    }
                    .fontStyle(.body3)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex:"FAE300"))
                    .cornerRadius(8)
                }
                
                Button(action: {
                    // Apple 로그인 액션
                }) {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Apple로 로그인")
                    }
                    .fontStyle(.body3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    // 로그인 없이 사용하기 액션
                }) {
                    Text("로그인 없이 사용하기")
                        .fontStyle(.caption)
                        .foregroundStyle(.gray4)
                        .padding(.top,8)
                        .padding(.top,16)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear{setupAppearance()}
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
                .fontStyle(.heading)
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
