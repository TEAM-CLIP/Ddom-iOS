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
    
    @Published var searchQuery:String { didSet{
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
    
    @Published var recentSearches: [String]
    @Published var isRegisterationPopupPresent: Bool = false
    @Published var isLoading: Bool = false
    
    
    private let storeService: StoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(storeService: StoreServiceProtocol = StoreService(),
         recentSearches:[String] = [],
         searchQuery:String = ""
    ) {
        self.storeService = storeService
        self.recentSearches = recentSearches
        self.searchQuery = searchQuery
        fetchInitialData()
    }
    
    // 최종 헤더에 가게 이름도 표시해야하기 때문에, selectedLocation을 zone 타입으로
    func selectLocation(_ zone: Zone) {
        print("selectLocation")
        selectedLocation = zone
        getStores()
    }
    
    func registerStore(_ id: String) {
        print("registerStore")
//        storeService.postLike(for: id)
    }
    
    func selectSearchResult(_ store: Store){
        if !recentSearches.contains(store.storeName){
            recentSearches.insert(store.storeName, at: 0)
        }
        //TODO: id갑 들고 화면 이동
        print("moveToDetailView")
    }
    
    func selectStore(_ id:String ){
        //TODO: id갑 들고 화면 이동
        print("selectStore")
    }
    
    func removeRecentSearch(_ text: String){
        recentSearches=recentSearches.filter{$0 != text}
    }
    
    func clearRecentSearch(){
        recentSearches=[]
    }
    
    func getStores() {
        guard let locationId = selectedLocation?.id else { return }
        isLoading = true
        storeService.getStores(for: locationId)
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
    private func fetchInitialData(){
        isLoading = true
        print("fetching InitialData")
        storeService.getZones()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("fetchInitialData: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    zones = res.zone
                    guard let _selectedLocation = res.zone.first else {return}
                    selectedLocation = _selectedLocation
                    getStores()
                case .error(let errorResponse):
                    print("fetchInitialData Error: \(errorResponse.code)")
                default:
                    print("exceptional")
                }
            }
            .store(in: &cancellables)
    }
    
    
}
