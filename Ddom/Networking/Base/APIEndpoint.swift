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
    case validateToken // Token
    case socialLogin(String) // Provider
    case deleteAccount(String) // email
    case mock(String) // tmp endpoint
    var path: String {
        switch self {
        case .signUp:
            return "/auth/register"
        case .validateToken:
            return "/auth/validate-token"
        case .checkUsername:
            return "/auth/check"
        case .socialLogin(let provider):
            return "/auth/social/\(provider)"
        case .deleteAccount(let email):
            return "/auth/\(email)"
        case .mock(let endpoint):
            return "/\(endpoint)"
        }
    }
}
