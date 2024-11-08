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
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil
    ) -> AnyPublisher<APIResult<T>, APIError> {
        return Future { promise in
            guard let token = KeychainManager.shared.getAccessToken() else {
                self.handleUnauthorized()
                promise(.failure(.unauthorized))
                return
            }
            
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            
            AF.request(
                APIConstants.baseUrl + endpoint.path,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseData { response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401: // Unauthorized
                        self.handleUnauthorized()
                        promise(.failure(.unauthorized))
                        return
                        
                    default: break
                    }
                }
                
                switch response.result {
                case .success(let data):
                    if let statusCode = response.response?.statusCode {
                        do {
                            let result = try APIResult<T>(statusCode: statusCode, data: data)
                            promise(.success(result))
                        } catch {
                            promise(.failure(.decodingError))
                        }
                    }
                case .failure(let error):
                    promise(.failure(APIError(afError: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestWithoutAuth<T: Decodable>(
        _ endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil
    ) -> AnyPublisher<APIResult<T>, APIError> {
        return Future { promise in
            AF.request(
                APIConstants.baseUrl + endpoint.path,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let statusCode = response.response?.statusCode {
                        do {
                            let result = try APIResult<T>(statusCode: statusCode, data: data)
                            promise(.success(result))
                        } catch {
                            promise(.failure(.decodingError))
                        }
                    }
                case .failure(let error):
                    promise(.failure(APIError(afError: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleUnauthorized() {
        UserDefaultsManager.shared.logout()
    }
}
