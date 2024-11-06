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
        getStores(selectedLocation:zone)
    }
    
    private func fetchInitialData() {
        isLoading = true
        print("fetchInitialData")
        storeService.getZones()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching data: \(error)")
                }
            } receiveValue: { [weak self] (statusCode,data) in
                guard let self = self else { return }
                
                if statusCode == 200 {
                    if let res = try? JSONDecoder().decode(ZoneResponse.self, from: data) {
                        zones = res.zone
                        print("asdf\(res)")
                        guard let _selectedLocation = res.zone.first else {return}
                        selectedLocation = _selectedLocation
                        getStores(selectedLocation: _selectedLocation)
                        print("asdf\(res)")
                    }
                    print("heelo")
                } else {
                    print("Unexpected status code in getZones: \(statusCode)")
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
                    print("Error fetching data: \(error)")
                }
            } receiveValue: { [weak self] (statusCode,data)  in
                guard let self = self else { return }
                if statusCode == 200 {
                    if let res = try? JSONDecoder().decode(StoreResponse.self, from: data) {
                        registeredStores = res.registered
                        nonRegisteredStores = res.nonRegistered
                    }
                } else {
                    print("Unexpected status code in getStores: \(statusCode)")
                }
            }
            .store(in: &cancellables)
    }
}
