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
        verifyUsername()
    }
    
    func verifyUsername() {
        isLoading = true
        authService.verifyUsername(username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (statusCode, data) in
                guard let self = self else {return}
                if statusCode == 200 {
                    if let res = try? JSONDecoder().decode(VerifyNicknameResponse.self, from: data) {
                        if res.isDuplicated {
                            errorText="닉네임 중복입니다"
                        } else {
                            isUsernameValid = true
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func signUp() {
        isLoading = true
        let params = [
            "registerToken": UserDefaults.standard.string(forKey: "registerToken") ?? "dummyRegisterToken",
            "servicePermission":isServiceChecked,
            "privatePermission":isPrivacyChecked,
            "advertisingPermission":isAdvertisementChecked,
            "marketingPermission":isMarketingChecked,
            "nickname": username,
            "phoneNumber": phone
        ] as [String : Any]
        
        authService.signUp(params)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (statusCode, data) in
                guard let self = self else {return}
                print(statusCode)
                if statusCode == 200 {
                    if let res = try? JSONDecoder().decode(SignUpResponse.self, from: data) {
                        handleSuccessfulLogin(
                            accessToken: res.accessToken,
                            refreshToken: res.refreshToken
                        )
                    }
                } else {
                    print("Unexpected status code: \(statusCode)")
                }
            }
            .store(in: &cancellables)
    }
    
    func handleSuccessfulLogin(accessToken: String,refreshToken:String) {
        do {
            try KeychainManager.shared.save(token: accessToken, forKey: "accessToken")
            try KeychainManager.shared.save(token: refreshToken, forKey: "refreshToken")
            appState.isLoggedIn = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
