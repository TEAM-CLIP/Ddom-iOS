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
    func request(
        _ endpoint: APIEndpoint,
        method: HTTPMethod,
        parameters: Parameters?
    ) -> AnyPublisher<(Int,Data), APIError>
    
    func requestWithoutAuth(
           _ endpoint: APIEndpoint,
           method: HTTPMethod,
           parameters: Parameters?
       ) -> AnyPublisher<(Int, Data), APIError>
}

protocol AuthServiceProtocol {
    func socialLogin(idToken: String, provider: String) -> AnyPublisher<(Int, Data), APIError>
//    func socialLogin(idToken: String, provider: String) -> AnyPublisher<LoginResult, APIError>
    func signUp(_ params: [String:Any] ) -> AnyPublisher<(Int, Data), APIError>
    func verifyUsername(_ username:String) -> AnyPublisher<(Int, Data),APIError>
}

protocol StoreServiceProtocol{
    func getZones() -> AnyPublisher<(Int, Data), APIError>
    func getStores(for locationId:String) -> AnyPublisher<(Int, Data), APIError>
}
