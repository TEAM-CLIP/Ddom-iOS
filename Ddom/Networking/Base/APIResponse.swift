//
//  APIResponse.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

struct SocialLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct RegisterTokenResponse: Codable {
    let registerToken: String
}

struct ErrorResponse: Codable {
    let message: String
    let code: String
}

struct SignUpResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct VerifyNicknameResponse: Codable {
    let isDuplicated: Bool
}

struct GetZoneResponse: Codable {
    let zone: [Zone]
}

struct GetStoreResponse: Codable {
    let registered: [Store]
    let unregistered: [Store]
}
