//
//  StoreListViewModel.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

import Foundation
import Combine
import SwiftUI

class StoreListViewModel: ObservableObject {
    @Published var path = NavigationPath()
    
    @Published var searchQuery = "" { didSet{
        if searchQuery.isEmpty {
            filteredStores = []
        } else {
            filteredStores = registeredStores.filter {
                $0.storeName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }}
    
    @Published var registeredStores: [Store] = []
    @Published var nonRegisteredStores: [Store] = []
    @Published var selectedLocation: Zone? = nil
    @Published var zones: [Zone] = []
    @Published var filteredStores: [Store] = []
    
    @Published var recentSearches: [String] = []
    @Published var isRegisterationPopupPresent: Bool = false
    @Published var isLoading: Bool = false
    
    
    private let storeService: StoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
        fetchInitialData()
    }
    
    func selectLocation(_ zone: Zone) {
        print("selectLocation")
        selectedLocation = zone
        getStores(selectedLocation:zone)
    }
    
    private func fetchInitialData(){
        isLoading = true
        storeService.getZones()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    zones = res.zone
                    guard let _selectedLocation = res.zone.first else {return}
                    selectedLocation = _selectedLocation
                    getStores(selectedLocation: _selectedLocation)
                case .error(let errorResponse):
                    print("fetchInitialData Error: \(errorResponse.code)")
                default:
                    print("exceptional")
                }
            }
            .store(in: &cancellables)
    }
    
    private func getStores(selectedLocation:Zone) {
        isLoading = true
        storeService.getStores(for: selectedLocation.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("getStores:\(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    nonRegisteredStores = res.unregistered
                    registeredStores = res.registered
                    
                case .error(let errorResponse):
                    print("getStores Error: \(errorResponse.code)")
                default:
                    print("exceptional")
                }
            }
            .store(in: &cancellables)
    }
}
