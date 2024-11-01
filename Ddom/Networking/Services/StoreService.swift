import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class StoreService:StoreServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    func fetchLocations() -> AnyPublisher<ZoneResponse, APIError> {
        return networkService.request(.mock("379024f0-0418-4fd4-949d-a2ccedf09c71"),method: .get, parameters: nil)
    }
    
    func fetchRestaurants(for locationId:String) -> AnyPublisher<StoreResponse, APIError> {
        return networkService.request(.mock("346c9e5a-51b6-481e-9c62-11a45a3158ca/region=\(locationId)"), method: .get, parameters: nil)
    }
}
