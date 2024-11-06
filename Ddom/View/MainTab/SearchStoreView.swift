//
//  SearchStoreView.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
import SwiftUI

struct SearchStoreView: View {
    @ObservedObject var viewModel : StoreListViewModel
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Button(action: {
                    dismiss()
                }) {
                    Image("arrow_left")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                HStack(spacing: 8) {
                    Image("search")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray10)
                    
                    TextField("찾고 싶은 가게를 검색해주세요", text: $viewModel.searchQuery)
                        .fontStyle(.body4)
                        .tint(.primary9)
                        .foregroundStyle(.gray10)
                        .focused($isFocused)
                        
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.gray5)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 36)
                .background(.surface1)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            Divider()
                .foregroundStyle(.gray2)
            
            if viewModel.searchQuery.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    if !viewModel.recentSearches.isEmpty {
                        Text("최근 검색")
                            .fontStyle(.body3)
                            .foregroundStyle(.gray10)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        
//                        ForEach(viewModel.recentSearches, id: \.self) { search in
//                            RecentSearchRow(search: search) {
//                                viewModel.removeRecentSearch(search)
//                            }
//                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredStores, id: \.id) { store in
                            SearchResultRow(store: store, searchQuery: viewModel.searchQuery)
                            
                            Divider()
                                .foregroundStyle(.gray2)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .toolbar(.hidden)

    }
}

struct SearchResultRow: View {
    let store: Store
    let searchQuery: String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: store.storeImgUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.gray2)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            Text(store.storeName)
                .fontStyle(.body4)
                .foregroundStyle(.gray10)
                .attributedText(searchQuery, color: .primary9)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
    }
}

struct RecentSearchRow: View {
    let search: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(search)
                .fontStyle(.body4)
                .foregroundStyle(.gray10)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        
        Divider()
            .foregroundStyle(.gray2)
    }
}
