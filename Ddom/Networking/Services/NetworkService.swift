//
//  NetworkService.swift
//  Ddom
//
//  Created by Neoself on 10/31/24.
//
import Foundation
import Alamofire
import Combine

class NetworkService: NetworkServiceProtocol {
    func request(
        _ endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil
    ) -> AnyPublisher<(Int, Data), APIError> {
        return Future { promise in
            var headers: HTTPHeaders = [:]
            if AppState.shared.isGuestMode {
                print("requesting API in guest Mode: returning...")
                return
            }
            
            if let token = KeychainManager.shared.getAccessToken() {
                headers = ["Authorization": "Bearer \(token)"]
            } else if APIConstants.isDevelopment {
                headers = ["Authorization": "Bearer dummyToken"]
            } else {
                promise(.failure(.unauthorized))
                return
            }
            
            AF.request(
                APIConstants.baseUrl + endpoint.path,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseData { response in
                if let statusCode = response.response?.statusCode,
                   let data = response.data {
                    promise(.success((statusCode, data)))
                } else if let error = response.error {
                    promise(.failure(APIError(afError: error)))
                } else {
                    promise(.failure(.unknown))
                }
            }
            //MARK: Legacy
//            .responseDecodable(of: T.self) { response in
//                switch response.result {
//                case .success(let value):
//                    promise(.success(value))
//                case .failure(let error):
//                    promise(.failure(APIError(afError: error)))
//                }
//            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestWithoutAuth(
           _ endpoint: APIEndpoint,
           method: HTTPMethod = .get,
           parameters: Parameters? = nil
       ) -> AnyPublisher<(Int, Data), APIError> {
           return Future { promise in
               AF.request(
                   APIConstants.baseUrl + endpoint.path,
                   method: method,
                   parameters: parameters,
                   encoding: JSONEncoding.default
               )
               .validate()
               .responseData { response in
                   if let statusCode = response.response?.statusCode,
                      let data = response.data {
                       promise(.success((statusCode, data)))
                   } else if let error = response.error {
                       promise(.failure(APIError(afError: error)))
                   } else {
                       promise(.failure(.unknown))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
}
