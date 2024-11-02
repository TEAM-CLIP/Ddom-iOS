//
//  APIResponse.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

struct StoreResponse: Codable {
    let registered: [Store]
    let nonRegistered: [Store]
}

struct ZoneResponse: Codable {
    let zone: [Zone]
}

struct LoginResponse: Codable {
    let user: User
    let token: String
}

enum APIResponse: Decodable {
    case success(AuthTokenResponse)
    case needsRegistration(RegisterTokenResponse)
    case error(ErrorResponse)
}

struct AuthTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

// 인증 필요 응답 (401)
struct RegisterTokenResponse: Codable {
    let registerToken: String
}

// 에러 응답 (4XX)
struct ErrorResponse: Codable {
    let message: String
    let code: String
}
