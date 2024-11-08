import Foundation
import SwiftUI
import Combine
import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class OnboardingViewModel: ObservableObject {
    private let userDefaults = UserDefaultsManager.shared
    
    @Published var navigationPath = NavigationPath()
    @Published var isSocialLoading: Bool = false
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - 소셜로그인 관련 메서드
    func performKakaoLogin() {
        isSocialLoading = true
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("performKakaoLogin1:\(error)")
                    self?.isSocialLoading = false
                    return
                }
                
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(for:"KAKAO", with:token, email:"")
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("performKakaoLogin2:\(error)")
                    self?.isSocialLoading = false
                    return
                }
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(for:"KAKAO", with:token, email:"")
                }
            }
        }
    }
    
    // TODO: Apple 처음 로그인 시, 이메일 값 UserDefaults로 저장 구현후, 서버에 같이 인자로 전달
    func performAppleLogin(_ result: ASAuthorization) {
        isSocialLoading = true
        
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential else {
            print("Error: Unexpected credential type")
            isSocialLoading = false
            return
        }
        
        if let email = appleIDCredential.email {
            userDefaults.saveAppleUserEmail(email, for: appleIDCredential.user)
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("Error: Unable to fetch identity token or authorization code")
            isSocialLoading = false
            return
        }
        
        authenticateWithServer(
            for:"APPLE",
            with:identityToken,
            email: userDefaults.getAppleUserEmail(for: appleIDCredential.user)
        )
    }
    
    private func authenticateWithServer(for provider:String, with idToken: String, email:String?) {
        authService.socialLogin(idToken: idToken, provider: provider, email:email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("authenticateWithServer:\(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let res):
                    handleSuccessfulLogin(
                        accessToken: res.accessToken,
                        refreshToken: res.refreshToken
                    )
                    
                case .redirect(let res):
                    navigationPath.append(Route.createAccount(registerToken: res.registerToken))
                    
                    
                case .error(let errorResponse):
                    print("Unexpected status code: \(errorResponse.code)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleSuccessfulLogin(accessToken: String, refreshToken:String) {
        KeychainManager.shared.saveTokens(accessToken, refreshToken)
        userDefaults.login()
    }
}
