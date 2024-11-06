//
//  APIResponse.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
enum APIResponse: Decodable {
    case socialLo(SocialLoginResponse)
    case needsRegistration(RegisterTokenResponse)
    case error(ErrorResponse)
}

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

struct RegisterTokenResponse: Codable {
    let registerToken: String
}

struct SocialLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
struct SignUpResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
struct VerifyNicknameResponse : Codable {
    let isDuplicated : Bool
}
// 에러 응답 (4XX)
struct ErrorResponse: Codable {
    let message: String
    let code: String
}
