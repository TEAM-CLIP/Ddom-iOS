//
//  APIEndpoint.swift
//  tyte
//
//  Created by 김 형석 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case signUp
    case checkUsername
    case reissueToken
    case socialLogin(String) // Provider
    case deleteAccount(String) // email
    case mock(String) // tmp endpoint
    var path: String {
        switch self {
        case .signUp:
            return "/users"
        case .reissueToken:
            return "/auth/reissue"
        case .checkUsername:
            return "/users/verify/nickname"
        case .socialLogin(let provider):
            return "/auth/login/\(provider)"
        case .deleteAccount(let email):
            return "/auth/\(email)"
        case .mock(let endpoint):
            return "/\(endpoint)"
        }
    }
}
