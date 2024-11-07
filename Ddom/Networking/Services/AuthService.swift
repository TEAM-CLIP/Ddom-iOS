import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire

class AuthService: AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
        // 구체적인 apiManager 클래스를 직접 주입하는 것이 아닌, 인터페이스만 하위속성으로 명시 후, 초기화 시 주입
    ) {
        self.networkService = networkService
    }
    
    func socialLogin(idToken: String, provider: String) -> AnyPublisher<APIResult<SocialLoginResponse>, APIError> {
        return networkService.requestWithoutAuth(.socialLogin(provider), method: .post, parameters: ["accessToken": idToken] )
    }
    
    func signUp(_ params:[String:Any]) -> AnyPublisher<APIResult<SignUpResponse>, APIError> {
        return networkService.requestWithoutAuth(.signUp, method: .post, parameters: params)
    }
    
    func verifyUsername(_ username: String) -> AnyPublisher<APIResult<VerifyNicknameResponse>, APIError> {
        let parameters = ["nickname": username]
        return networkService.requestWithoutAuth(.checkUsername, method: .post, parameters: parameters)
    }
}
