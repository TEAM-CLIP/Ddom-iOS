//
//  ServiceProtocol.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

import Combine
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        method: HTTPMethod,
        parameters: Parameters?
    ) -> AnyPublisher<T, APIError>
    
    func requestWithoutAuth<T: Decodable>(_ endpoint: APIEndpoint,
                                          method: HTTPMethod,
                                          parameters: Parameters?) -> AnyPublisher<T, APIError>
}

protocol AuthServiceProtocol {
    func socialLogin(idToken: String, provider:String) -> AnyPublisher<LoginResponse, APIError>
    func signUp(username: String, phone: String) -> AnyPublisher<LoginResponse, APIError>
    func checkUsername(_ username:String) -> AnyPublisher<Bool,APIError>
}

protocol StoreServiceProtocol{
    func fetchLocations() -> AnyPublisher<ZoneResponse, APIError>
    func fetchRestaurants(for locationId:String) -> AnyPublisher<StoreResponse, APIError>
}
