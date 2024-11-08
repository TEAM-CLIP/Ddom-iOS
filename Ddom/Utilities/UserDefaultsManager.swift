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
        print("getAppleUserEmail from UserDefaultsManager: \(appleUserEmails[userId] ?? "no email found")")
        return appleUserEmails[userId]
    }
    
    // - UserDefaults 업데이트 -> isLoggedInPublisher에 새 값 전달 -> AppState의 isLoggedIn 업데이트 -> UI 자동 갱신
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        KeychainManager.shared.clearToken()
        isLoggedIn = false
        username = nil
    }
}
