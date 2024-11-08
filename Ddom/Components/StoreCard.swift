//
//  StoreCArd.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
import SwiftUI

struct StoreCard: View {
    @ObservedObject var viewModel: StoreListViewModel
    let store: Store
    let isRegistered: Bool
    let onHeartClick:()->Void
    let onCardClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: store.storeImgUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray2)
                        ProgressView()
                    }
                }
                
                if isRegistered {
                    Text("\(store.favoriteUserCount ?? 0)명 단골")
                        .fontStyle(.caption1)
                        .foregroundStyle(.myWhite)
                        .padding(.horizontal,12)
                        .padding(.vertical,4)
                        .background(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 4,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0
                            )
                            .fill(.error)
                        )
                }
            }
            .frame(width: 92, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack (alignment: .leading, spacing:0) {
                Text(store.storeType)
                    .fontStyle(.body5)
                    .foregroundStyle(.gray6)
                
                Text(store.storeName)
                    .fontStyle(.title2)
                    .foregroundStyle(.gray10)
                    .padding(.bottom,8)
                
                if let discountPolicy = store.discountPolicy, isRegistered {
                    ForEach(discountPolicy, id:\.self){ policy in
                        Text(policy.discountDescription)
                            .fontStyle(.caption1)
                            .foregroundStyle(.gray4)
                    }
                }
            }
            
            Spacer()
            
            if isRegistered {
                Button(action: {onHeartClick()}
                ) {
                    Image("heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray10)
                        .padding(.leading,24)
                        .padding(.vertical,12)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(.myWhite)
        .opacity(isRegistered ? 1.0 : 0.5)
        
        .onTapGesture{onCardClick()}
    }
}
//MARK: - popup 테스트 용
//#Preview("StoreCard") {
//    StoreCard_Previews()
//}
//struct StoreCard_Previews: View {
//    @State private var showPopup = false
//    
//    var body: some View {
//        ZStack {
//            StoreCard(
//                viewModel: .mockViewModel(),
//                store:  Store(id: "1",
//                              storeName: "스타벅스 이대점",
//                              storeImgUrl: "https://picsum.photos/200/200",
//                              storeType: "카페",
//                              favoriteUserCount: 150,
//                              isFavorited: false,
//                              discountPolicy: [
//                                DiscountPolicy(discountType: "REGULAR", discountDescription: "매주 월요일 10% 할인"),
//                                DiscountPolicy(discountType: "FIRST", discountDescription: "첫 방문 15% 할인"),
//                                DiscountPolicy(discountType: "FIRST", discountDescription: "첫 방문 15% 할인")
//                              ]),
//                isRegistered: true,
//                onClick:{showPopup = true}
//            )
//            
//            if showPopup {
//                CustomPopupOneBtn(
//                    isShowing: $showPopup,
//                    popupData: .storeRegister {
//                        print("Register action")
//                    }
//                )
//            }
//        }
//        .environmentObject(AppState())
//    }
//}
