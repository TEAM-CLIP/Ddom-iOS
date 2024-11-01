// MARK: - StoreResponse


struct RegisteredStore: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let favoriteUserCount: Int
    let isFavorited: Bool
    let category: String
    let discountType: String
    let discountDescription: String
    
}

struct NonRegisteredStore: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let category: String
}

struct Store: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let category: String
    let favoriteUserCount: Int?
    let isFavorited: Bool?
    let discountType: String?
    let discountDescription: String?
}
