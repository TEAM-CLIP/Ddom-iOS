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
    private let authService: AuthService
    
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
        checkLoginStatus()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func checkLoginStatus() {
        if let savedEmail = UserDefaults.standard.string(forKey: "lastLoggedInEmail") {
            do {
                let _ = try KeychainManager.retrieve(service: APIConstants.tokenService, account: savedEmail)
                print("isLoggedIn true")
            } catch{
                AppState.shared.isLoggedIn = false
            }
        } else {
            AppState.shared.isLoggedIn = false
        }
    }
    
    //MARK: - 소셜로그인 관련 메서드
    
    func performKakaoLogin() {
        isSocialLoading = true
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱을 통한 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self?.isSocialLoading = false
                    return
                }
                
                // 카카오 토큰을 성공적으로 받아왔을 때 서버 인증 진행
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(token)
                }
            }
        } else {
            // 카카오톡 앱이 설치되어 있지 않을 경우 웹 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self?.isSocialLoading = false
                    return
                }
                if let token = oauthToken?.accessToken {
                    self?.authenticateWithServer(token)
                }
            }
        }
    }
    
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
        
        self.authenticateWithServer(identityToken)
    }
    
    private func authenticateWithServer(_ idToken: String) {
        print("authenticateWithServer: \(idToken)")
        navigationPath.append(Route.createAccount)
        // MARK: 서버로부터 기존 사용자 여부 파악 -> 여부에 따라 CreateAccountView 이동 or appState.isLoggedIn True로
//        authService.authenticateSocialLoginWithServer(identityToken: idToken, provider: "kakao")
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isSocialLoading = false
//                if case .failure(let error) = completion {
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] loginResponse in
//                self?.handleSuccessfulLogin(loginResponse: loginResponse)
//            }
//            .store(in: &cancellables)
    }
    
    private func handleSuccessfulLogin(loginResponse: LoginResponse) {
        do {
            try KeychainManager.save(token: loginResponse.token,
                                     service: APIConstants.tokenService,
                                     account: loginResponse.user.email)
            print("lastLoggedInEmail changed into \(loginResponse.user.email)")
            UserDefaults.standard.set(loginResponse.user.email, forKey: "lastLoggedInEmail")
            appState.isLoggedIn = true
        } catch {
            
            print(error.localizedDescription)
        }
    }
}
