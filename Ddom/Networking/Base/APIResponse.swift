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
