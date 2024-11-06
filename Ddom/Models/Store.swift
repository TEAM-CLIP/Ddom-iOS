struct Store: Codable, Identifiable {
    let id: String
    let storeName: String
    let storeImgUrl: String
    let storeType: String
    
    // MARK: - Registered Store
    var favoriteUserCount: String?
    var isFavorited: Bool?
    let discountPolicy: DiscountPolicy?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "storeId"
        case storeName,storeImgUrl,storeType,favoriteUserCount,isFavorited,discountPolicy
    }
}

struct DiscountPolicy: Codable {
    let discountType: String
    let discountDescription: String
}
