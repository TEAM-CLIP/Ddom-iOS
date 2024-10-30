//
//  APIEndpoint.swift
//  tyte
//
//  Created by 김 형석 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case login
    case signUp
    case checkEmail
    case validateToken // Token
    case socialLogin(String) // Provider
    case deleteAccount(String) // email
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .signUp:
            return "/auth/register"
        case .validateToken:
            return "/auth/validate-token"
        case .checkEmail:
            return "/auth/check"
        case .socialLogin(let provider):
            return "/auth/social/\(provider)"
        case .deleteAccount(let email):
            return "/auth/\(email)"
        }
    }
}
