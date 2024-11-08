import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class StoreService: StoreServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    func getZones() -> AnyPublisher<APIResult<GetZoneResponse>, APIError> {
        return networkService.request(.getZones,method: .get, parameters: nil)
    }
    
    func getStores(for locationId:String) -> AnyPublisher<APIResult<GetStoreResponse>, APIError> {
        return networkService.request(.getStores, method: .get, parameters: nil)
    }
}
