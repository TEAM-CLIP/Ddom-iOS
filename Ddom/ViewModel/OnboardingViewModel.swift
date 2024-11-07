import Foundation
import SwiftUI
import Combine
import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class OnboardingViewModel: ObservableObject {
    private let appState: AppState = AppState.shared
    
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
                    print(error.localizedDescription)
                    self?.isSocialLoading = false
                    return
                }
                
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(for:"KAKAO", with:token)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self?.isSocialLoading = false
                    return
                }
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(for:"KAKAO", with:token)
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
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("Error: Unable to fetch identity token or authorization code")
            isSocialLoading = false
            return
        }
        
        authenticateWithServer(for:"APPLE", with:identityToken)
    }
    
    private func authenticateWithServer(for provider:String, with idToken: String) {
        authService.socialLogin(idToken: idToken, provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
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
                    UserDefaults.standard.set(res.registerToken, forKey: "registerToken")
                    navigationPath.append(Route.createAccount)
                    
                case .error(let errorResponse):
                    print("Unexpected status code: \(errorResponse.code)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleSuccessfulLogin(accessToken: String,refreshToken:String) {
        do {
            print("accessToken:\(accessToken)")
            try KeychainManager.shared.save(token: accessToken, forKey: "accessToken")
            try KeychainManager.shared.save(token: refreshToken, forKey: "refreshToken")
            appState.isLoggedIn = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
