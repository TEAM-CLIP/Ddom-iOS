//
//  ServiceProtocol.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

import Combine
import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod, parameters: Parameters?) -> AnyPublisher<APIResult<T>, APIError>
    func requestWithoutAuth<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod, parameters: Parameters?) -> AnyPublisher<APIResult<T>, APIError>
}

protocol AuthServiceProtocol {
    // 소셜 로그인
    func socialLogin(idToken: String, provider: String,email:String?) -> AnyPublisher<APIResult<SocialLoginResponse>, APIError>
    // 회원가입
    func signUp(_ params: [String: Any]) -> AnyPublisher<APIResult<SignUpResponse>, APIError>
    // 닉네임 검증
    func verifyUsername(_ username: String) -> AnyPublisher<APIResult<VerifyNicknameResponse>, APIError>
}

protocol StoreServiceProtocol {
    // 지역 정보 조회
    func getZones() -> AnyPublisher<APIResult<GetZoneResponse>, APIError>
    // 특정 지역의 상점 조회
    func getStores(for locationId: String) -> AnyPublisher<APIResult<GetStoreResponse>, APIError>
}
