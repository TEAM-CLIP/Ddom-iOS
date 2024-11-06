//
//  CreateAccountViewModel.swift
//  Ddom
//
//  Created by Neoself on 10/30/24.
//

import Foundation
import SwiftUI
import Combine

class CreateAccountViewModel: ObservableObject {
    private let appState: AppState = AppState.shared
    
    @Published var username: String = "" { didSet{
        if username != oldValue {
            withAnimation (.mediumEaseInOut){
                isUsernameValid = false
                errorText = ""
            }
        }
    }}
    
    @Published var phone: String = "" {
        didSet {
            let numbers = phone.filter { $0.isNumber } // 숫자만 추출
            // 최대 11자리로 제한
            if numbers.count > 11 {
                phone = oldValue
                return
            }
            
            // 형식에 맞게 하이픈 추가
            let formattedNumber = formatPhoneNumber(numbers)
            
            // 현재 입력값이 이미 포맷된 값과 다르다면 업데이트
            if phone != formattedNumber {
                phone = formattedNumber
            }
        }
    }
    
    @Published var errorText: String = ""
    @Published var isUsernameValid: Bool = false
    @Published var isDetailViewPresent: Bool = false
    @Published var isLoading:Bool = false
    
    @Published var isServiceChecked:Bool = false
    @Published var isPrivacyChecked:Bool = false
    @Published var isAdvertisementChecked:Bool = false
    @Published var isMarketingChecked:Bool = false
    
    var isAllChecked:Bool {
        isServiceChecked &&
        isPrivacyChecked &&
        isAdvertisementChecked &&
        isMarketingChecked
    }
    
    func toggleAllChecks() {
        let newValue = !isAllChecked
        withAnimation(.fastEaseOut) {
            isServiceChecked = newValue
            isPrivacyChecked = newValue
            isAdvertisementChecked = newValue
            isMarketingChecked = newValue
        }
    }
    
    var isAgreeButtonDisabled:Bool {
        !(isServiceChecked && isPrivacyChecked) ||
        isLoading
    }
    
    var isSignUpButtonDisabled:Bool {
        username.isEmpty ||
        phone.isEmpty ||
        !isUsernameValid ||
        isLoading
    }
    
    private let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func formatPhoneNumber(_ numbers: String) -> String {
        var result = ""
        let length = numbers.count
        
        for (index, char) in numbers.enumerated() {
            if index == 3 || (index == 7 && length > 7) {
                result += "-"
            }
            result.append(char)
        }
        return result
    }
    
    func handleSubmit(){
        isDetailViewPresent = false
        signUp()
    }
    
    func handleDuplicateCheckButton(){
        if username.count<2 {
            withAnimation(.mediumEaseInOut){
                errorText = "2자 이상 입력해주세요"
                return
            }
        } else if username.count>8  {
            withAnimation(.mediumEaseInOut){
                errorText="최대 8자까지 가능해요"
                return
            }
        }
        // MARK: 서버로부터 중복여부 체크 로직 수행
        // errorText="닉네임 중복입니다"
        isUsernameValid = true
    }
    
    func signUp() {
        appState.isLoggedIn = true
        //        authService.signUp(username: username, phone: phone)
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] completion in
        //                self?.isLoading = false
        //                if case .failure(let error) = completion {
        //
        //                    print(error.localizedDescription)
        //                }
        //            } receiveValue: { [weak self] signUpResponse in
        //                self?.handleSuccessfulLogin(loginResponse: signUpResponse)
        //            }
        //            .store(in: &cancellables)
    }
    
//    private func handleSuccessfulLogin(loginResponse: LoginResponse) {
//        do {
//            try KeychainManager.shared.save(token: loginResponse.token,
//                                            service: APIConstants.tokenService,
//                                            account: loginResponse.user.username)
//            UserDefaults.standard.set(loginResponse.user.username, forKey: "lastLoggedInUsername")
//            appState.isLoggedIn = true
//        } catch {
//            print(error.localizedDescription)
////            currentToast = .error(error.localizedDescription)
//        }
//    }
}

