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
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }}
    
    @Published var registeredStores: [Store] = []
    @Published var nonRegisteredStores: [Store] = []
    @Published var selectedLocation: Zone? = nil
    @Published var zones: [Zone] = []
    @Published var filteredStores: [Store] = []
    
    @Published var recentSearches: [String] = []
    
    let description = [
        "이대신촌":"신촌동, 봉원동, 창천동, 대현동 등",
        "건대성수":"성수동, 화양동 등"
    ]
    
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
        fetchStores(selectedLocation:zone)
    }
    
    private func fetchInitialData() {
        isLoading = true
        
        storeService.fetchLocations()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching data: \(error)")
                }
            } receiveValue: { [weak self] zoneResponse in
                print("fetchLocations-zoneResponse: \(zoneResponse)")
                self?.zones = zoneResponse.zone
                guard let selectedLocation = zoneResponse.zone.first else {return}
                self?.selectedLocation = selectedLocation
                self?.fetchStores(selectedLocation: selectedLocation)
            }
            .store(in: &cancellables)
    }
    
    private func fetchStores(selectedLocation:Zone) {
        isLoading = true
        storeService.fetchRestaurants(for: selectedLocation.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching data: \(error)")
                }
            } receiveValue: { [weak self] stores in
                print("fetchStores-stores: \(stores)")
                self?.registeredStores = stores.registered
                self?.nonRegisteredStores = stores.nonRegistered
            }
            .store(in: &cancellables)
    }
}

//storeService.fetchRestaurants()

