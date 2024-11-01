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
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: store.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray2)
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
                Text(store.category)
                    .fontStyle(.body5)
                    .foregroundStyle(.gray6)
                
                Text(store.name)
                    .fontStyle(.title2)
                    .foregroundStyle(.gray10)
                    .padding(.bottom,8)
                
                if isRegistered {
                    Text(store.discountDescription ?? "설명 없음")
                        .fontStyle(.title2)
                        .foregroundStyle(.primary9)
                }
            }
            
            Spacer()
            
            if isRegistered {
                Button(action: {print("pressed")}) {
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
        .opacity(isRegistered ? 1.0 : 0.7)
    }
}

