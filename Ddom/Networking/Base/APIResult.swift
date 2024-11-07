//
//  APIResult.swift
//  Ddom
//
//  Created by Neoself on 11/7/24.
//

// Response = 일반적으로 서버로부터 받은 "응답 데이터" 자체를 의미 -> 데이터 구조체에 더 적합
// Result = 성공/실패/리다이렉션 등 다양한 결과 상태를 포함 -> 작업의 결과를 나타내는데 더 적합
import Foundation

enum APIResult<T:Decodable> {// API 응답 열거형 정의
    case success(T)
    case redirect(RegisterTokenResponse)  // 201 등의 리다이렉션 응답
    case error(ErrorResponse)
    
    init(statusCode: Int, data: Data) throws {
        let decoder = JSONDecoder()
        
        switch statusCode {
        case 200..<300:
            if statusCode == 201 {
                let response = try decoder.decode(RegisterTokenResponse.self, from: data)
                self = .redirect(response)
            } else {
                let response = try decoder.decode(T.self, from: data)
                self = .success(response)
            }
        case 400..<500:
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            self = .error(errorResponse)
        default:
            throw APIError.unknown
        }
    }
}
