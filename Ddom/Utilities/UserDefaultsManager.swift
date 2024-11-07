//
//  UserDefaultsManager.swift
//  Ddom
//
//  Created by Neoself on 11/7/24.
//
import Foundation

enum UserDefaultsKeys {
    static let isLoggedIn = "isLoggedIn"
    static let username = "username"
    static let lastLoggedInEmail = "lastLoggedInEmail"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults: UserDefaults
    
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - 속성들 캡슐화와 데이터 무결성을 보장하기 위해 private(set) 사용 ->  클래스 내부에서만 수정 가능
    // 읽기는 public, 쓰기는 private
    private(set) var isLoggedIn: Bool {
        get { defaults.bool(forKey: UserDefaultsKeys.isLoggedIn) }
        set { defaults.set(newValue, forKey: UserDefaultsKeys.isLoggedIn) }
    }
    
    private(set) var username: String? {
        get { defaults.string(forKey: UserDefaultsKeys.username) }
        set { defaults.set(newValue, forKey: UserDefaultsKeys.username) }
    }
    
    private(set) var lastLoggedInEmail: String? {
        get { defaults.string(forKey: UserDefaultsKeys.lastLoggedInEmail) }
        set { defaults.set(newValue, forKey: UserDefaultsKeys.lastLoggedInEmail) }
    }
    
    // MARK: - 메서드들
    func clearUserSession() {
        isLoggedIn = false
        username = nil
        lastLoggedInEmail = nil
    }
    
    func saveEmail(_ email:String){
        lastLoggedInEmail = email
    }
    
    func login() {
        isLoggedIn = true
    }
    
    // 특정 키만 삭제
    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
