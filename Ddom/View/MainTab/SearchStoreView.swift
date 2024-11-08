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
            HStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Image("arrow_left")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.vertical,12)
                .padding(.trailing,16)
                
                HStack(spacing: 12) {
                    Image("search")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray3)
                    
                    TextField("찾고 싶은 가게를 검색해주세요", text: $viewModel.searchQuery)
                        .fontStyle(.body4)
                        .foregroundStyle(.gray10)
                        .focused($isFocused)
                    
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.gray3)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 48)
                .background(RoundedRectangle(cornerRadius: 8).fill(.surface1))
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 24)
            
            if viewModel.searchQuery.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack (alignment:.center) {
                        Text("최근 검색어")
                            .fontStyle(.body3)
                            .foregroundStyle(.gray7)
                        
                        Spacer()
                        
                        Button(action:{viewModel.clearRecentSearch()}){
                            Text("전체 삭제")
                                .fontStyle(.caption)
                                .foregroundStyle(.gray5)
                                .padding(.leading,12)
                                .padding(.vertical,4)
                        }
                    }
                    
                    if !viewModel.recentSearches.isEmpty {
                        LazyVStack(spacing:4){
                            ForEach(viewModel.recentSearches, id: \.self) { search in
                                RecentSearchRow(search: search) {
                                    viewModel.removeRecentSearch(search)
                                }
                            }
                        }
                    } else {
                        Text("검색 기록이 없어요")
                            .fontStyle(.body4)
                            .foregroundStyle(.gray5)
                    }
                }
                .padding(.horizontal,16)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredStores, id: \.id) { store in
                            SearchResultRow(store: store, searchQuery: viewModel.searchQuery){
                                viewModel.selectSearchResult(store)
                            }
                        }
                        .padding(.horizontal,16)
                    }
                }
            }
            
            Spacer()
        }
        .toolbar(.hidden)
        .background(.white)

        .onAppear {
            isFocused = true
        }

    }
}

struct SearchResultRow: View {
    let store: Store
    let searchQuery: String
    let onClick: () -> Void
    
    var body: some View {
        Button(action:onClick){
            VStack {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: store.storeImgUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    
                    Text(store.storeName)
                        .fontStyle(.body4)
                        .foregroundStyle(.gray10)
                        .attributedText(searchQuery, color: .primary9)
                    
                    Spacer()
                }
                .padding(.bottom, 12)
                
                Divider().background(.gray1)
            }
            .background(.white)
        }
    }
}

struct RecentSearchRow: View {
    let search: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(search)
                .fontStyle(.body4)
                .foregroundStyle(.gray8)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray3)
            }
            .padding(4)
        }
        .padding(.vertical, 8)
    }
}

#Preview("Default") {
    SearchStoreView(viewModel: .mockViewModel())
}
