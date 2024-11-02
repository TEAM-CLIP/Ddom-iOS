import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class AuthService:AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService() // 구체적인 apiManager 클래스를 직접 주입하는 것이 아닌, 인터페이스만 하위속성으로 명시 후, 초기화 시 주입
    ) {
        self.networkService = networkService
    }
    
    func socialLogin(idToken: String, provider:String) -> AnyPublisher<APIResponse, APIError> {
        return networkService.requestWithoutAuth(.socialLogin(provider),method: .post, parameters: ["accessToken": idToken])
    }
    
    func signUp(username: String, phone: String) -> AnyPublisher<LoginResponse, APIError> {
        let parameters: [String: Any] = ["username": username, "phone": phone]
        return networkService.requestWithoutAuth(.signUp, method: .post, parameters: parameters)
    }
    
    func checkUsername(_ username: String) -> AnyPublisher<Bool, APIError> {
        let parameters = ["username": username]
        return networkService.requestWithoutAuth(.checkUsername, method: .post, parameters: parameters)
    }
//    func deleteAccount(_ email: String) -> AnyPublisher<String, APIError> {
//        return networkService.request(.deleteAccount(email), method: .delete, parameters: nil)
//    }
    
//    func validateToken(_ token: String) -> AnyPublisher<Bool, APIError> {
//        return networkService.requestWithoutAuth(.validateToken, method: .post, parameters: ["token": token])
//    }
}
