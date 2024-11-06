//
//  HomeViewModel.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    private let appState: AppState = AppState.shared
    
    @Published var errorText: String = ""
    @Published var isUsernameValid: Bool = false
    @Published var isLoading:Bool = false
    
    private let storeService: StoreServiceProtocol
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func getLocations() {
        
    }
    
    
    func signUp() {
        appState.isLoggedIn = true
        //        authService.signUp(username: username, phone: phone)
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] completion in
        //                self?.isLoading = false
        //                if case .failure(let error) = completion {
        //
        //                    print(error.localizedDescription)
        //                }
        //            } receiveValue: { [weak self] signUpResponse in
        //                self?.handleSuccessfulLogin(loginResponse: signUpResponse)
        //            }
        //            .store(in: &cancellables)
    }

}

