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
        //        checkLoginStatus()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //    private func checkLoginStatus() {
    //        if let savedEmail = UserDefaults.standard.string(forKey: "lastLoggedInEmail") {
    //            do {
    //                let _ = try KeychainManager.shared.retrieve(forKey: "accessToken")
    //                print("isLoggedIn true")
    //            } catch{
    //                AppState.shared.isLoggedIn = false
    //            }
    //        } else {
    //            AppState.shared.isLoggedIn = false
    //        }
    //    }
    
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
                    self?.authenticateWithServer(for:"KAKAO", with:token)
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
                    self?.authenticateWithServer(for:"KAKAO", with:token)
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
        
        authenticateWithServer(for:"APPLE", with:identityToken)
    }
    
    func moveToMainTabView(){
        navigationPath.append(Route.createAccount)
    }
    
    private func authenticateWithServer(for provider:String, with idToken: String) {
        authService.socialLogin(idToken: idToken, provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSocialLoading = false
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else {return}
                switch response {
                case .success(let authResponse):
                    handleSuccessfulLogin(accessToken: authResponse.accessToken,
                                          refreshToken: authResponse.refreshToken)
                    
                case .needsRegistration(let registerResponse):
                    handleRegistration(registerToken: registerResponse.registerToken)
                    
                case .error(let errorResponse):
                    print(errorResponse.message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleRegistration(registerToken:String) {
        do{
            try KeychainManager.shared.save(token: registerToken, forKey: "registerToken")
            navigationPath.append(Route.createAccount)
        } catch {
            print("handleRegistration Failed:\(error.localizedDescription)")
        }
    }
    
    private func handleSuccessfulLogin(accessToken: String,refreshToken:String) {
        do {
            try KeychainManager.shared.save(token: accessToken, forKey: "accessToken")
            try KeychainManager.shared.save(token: refreshToken, forKey: "refreshToken")
            appState.isLoggedIn = true
        } catch {
            
            print(error.localizedDescription)
        }
    }
}
