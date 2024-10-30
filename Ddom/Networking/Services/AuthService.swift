import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

struct LoginResponse: Codable {
    let user: User
    let token: String
}

struct ValidateResponse: Codable {
    let isValid: Bool
}

struct CheckEmailResponse: Decodable {
    
    let isValid: Bool
}

class AuthService {
    static let shared = AuthService()
    private let apiManager: APIManager
    
    init(apiManager: APIManager = .shared) {
        self.apiManager = apiManager
    }
    
    func deleteAccount(_ email:String) -> AnyPublisher<String, APIError> {
        let endpoint = APIEndpoint.deleteAccount(email)
        
        return Future { promise in
            self.apiManager.request(endpoint,
                                    method: .delete,
                                    parameters: nil) { (result: Result<String, APIError>) in
                switch result {
                case .success(let response):
                    self.apiManager.clearToken()
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func validateToken(token:String) -> AnyPublisher<Bool, APIError> {
        let endpoint = APIEndpoint.validateToken
        return Future { promise in
            self.apiManager.requestWithoutAuth(endpoint,
                                               method: .post,
                                               parameters: ["token": token]) { (result: Result<ValidateResponse, APIError>) in
                switch result {
                case .success(let response):
                    promise(.success(response.isValid))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func checkEmail(_ email: String) -> AnyPublisher<Bool, APIError> {
        let endpoint = APIEndpoint.checkEmail
        return Future { promise in
            self.apiManager.requestWithoutAuth(endpoint,
                                               method: .post,
                                               parameters: ["email": email]) { (result: Result<CheckEmailResponse, APIError>) in
                switch result {
                case .success(let response):
                    promise(.success(response.isValid))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
        let endpoint = APIEndpoint.login
        return Future { promise in
            self.apiManager.requestWithoutAuth(endpoint,
                                               method: .post,
                                               parameters: ["email": email, "password": password]) { (result: Result<LoginResponse, APIError>) in
                switch result {
                case .success(let response):
                    self.apiManager.saveToken(response.token, for: response.user.email)
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(email: String, username: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
        let endpoint = APIEndpoint.signUp
        return Future { promise in
            self.apiManager.requestWithoutAuth(endpoint,
                                               method: .post,
                                               parameters: ["email": email, "username": username, "password": password]) { (result: Result<LoginResponse, APIError>) in
                switch result {
                case .success(let response):
                    self.apiManager.saveToken(response.token, for: response.user.email)
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func authenticateSocialLoginWithServer(identityToken: String,provider:String) -> AnyPublisher<LoginResponse, APIError> {
        let endpoint = APIEndpoint.socialLogin(provider)
        
        return Future { promise in
            self.apiManager.requestWithoutAuth(endpoint,
                                               method: .post,
                                               parameters: [ "identityToken":identityToken ]) { (result: Result<LoginResponse, APIError>) in
                switch result {
                case .success(let response):
                    self.apiManager.saveToken(response.token, for: response.user.email)
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
