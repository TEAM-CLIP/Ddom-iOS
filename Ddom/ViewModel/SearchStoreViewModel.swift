//
//  SearchStroeViewModel.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//

import Foundation
import Combine

class SearchStoreViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var stores: [RegisteredStore] = []
    @Published var recentSearches: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let storeService: StoreServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    var filteredStores: [RegisteredStore] {
        if searchQuery.isEmpty {
            return []
        }
        return stores.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
        //        loadRecentSearches()
        
        // Debounce search query to save recent searches
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                if !query.isEmpty {
                    self?.addRecentSearch(query)
                }
            }
            .store(in: &cancellables)
    }
    //
    //    func fetchStores() {
    //        storeService.fetchRestaurants()
    //            .receive(on: DispatchQueue.main)
    //            .sink { completion in
    //                if case .failure(let error) = completion {
    //                    print("Error fetching stores: \(error)")
    //                }
    //            } receiveValue: { [weak self] response in
    //                self?.stores = response.registered
    //            }
    //            .store(in: &cancellables)
    //    }
    //
    //    private func loadRecentSearches() {
    //        recentSearches = userDefaults.stringArray(forKey: "recentSearches") ?? []
    //    }
    //
    private func addRecentSearch(_ search: String) {
        var searches = recentSearches
        if let index = searches.firstIndex(of: search) {
            searches.remove(at: index)
        }
        searches.insert(search, at: 0)
        if searches.count > 10 {
            searches = Array(searches.prefix(10))
        }
        recentSearches = searches
        userDefaults.set(searches, forKey: "recentSearches")
    }
    //
    //    func removeRecentSearch(_ search: String) {
    //        recentSearches.removeAll { $0 == search }
    //        userDefaults.set(recentSearches, forKey: "recentSearches")
    //    }
}
