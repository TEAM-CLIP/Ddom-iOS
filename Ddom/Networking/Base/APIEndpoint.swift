//
//  APIEndpoint.swift
//  tyte
//
//  Created by 김 형석 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case getStores
    case getZones
    
    case reissueToken
    case socialLogin(String) // Provider
    case signUp
    case checkUsername
    
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
        case .getStores:
            return "/stores"
        case .getZones:
            return "/zones"
        }
    }
}
