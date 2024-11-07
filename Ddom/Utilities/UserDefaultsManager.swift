//
//  UserDefaultsManager.swift
//  Ddom
//
//  Created by Neoself on 11/7/24.
//
import Foundation
import Combine

enum UserDefaultsKeys {
    static let isLoggedIn = "isLoggedIn"
    static let username = "username"
    static let appleUserEmails = "appleUserEmails"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults: UserDefaults
    
    var isLoggedInPublisher: CurrentValueSubject<Bool, Never>
    
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isLoggedInPublisher = CurrentValueSubject<Bool, Never>(
            defaults.bool(forKey: "isLoggedIn")
        )
    }
    
    // MARK: - 속성들 캡슐화와 데이터 무결성을 보장하기 위해 private(set) 사용 ->  클래스 내부에서만 수정 가능
    // 읽기는 public, 쓰기는 private
    private(set) var isLoggedIn: Bool {
        get { defaults.bool(forKey: UserDefaultsKeys.isLoggedIn) }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.isLoggedIn)
            isLoggedInPublisher.send(newValue)
        }
    }
    
    private(set) var username: String? {
        get { defaults.string(forKey: UserDefaultsKeys.username) }
        set { defaults.set(newValue, forKey: UserDefaultsKeys.username) }
    }
    
    private(set) var appleUserEmails: [String: String] {
        get { defaults.dictionary(forKey: UserDefaultsKeys.appleUserEmails) as? [String: String] ?? [:] }
        set { defaults.set(newValue, forKey: UserDefaultsKeys.appleUserEmails) }
    }
    
    // MARK: - 메서드들
    
    func saveAppleUserEmail(_ email: String, for userId: String) {
        appleUserEmails[userId] = email
    }
    
    func getAppleUserEmail(for userId: String) -> String? {
        return appleUserEmails[userId]
    }
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        KeychainManager.shared.clearToken()
        isLoggedIn = false
        username = nil
    }
    // 특정 키만 삭제
    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
