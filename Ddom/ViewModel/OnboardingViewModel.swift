//
//  OnboardingViewModel.swift
//  Ddom
//
//  Created by Neoself on 10/27/24.
//
import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var isLoading = false
    @Published var error: Error?
    
    private let appState: AppState = AppState.shared
    
    func kakaoLogin() {
        isLoading = true
        navigationPath.append(Route.createAccount)
        
//        Task {
//            do {
//                let result = try await authService.kakaoLogin()
//                
//                await MainActor.run {
//                    switch result {
//                    case .needsRegistration:
//                        navigationPath.append(Route.createAccount)
//                    case .success(let user):
//                        appState.currentUser = user
//                        appState.isAuthenticated = true
//                    }
//                    isLoading = false
//                }
//            } catch {
//                await MainActor.run {
//                    self.error = error
//                    isLoading = false
//                }
//            }
//        }
    }
}
