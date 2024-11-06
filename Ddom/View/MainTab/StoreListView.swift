// StoreListView.swift
import SwiftUI

struct StoreListView: View {
    @StateObject private var viewModel = StoreListViewModel()
    
    var body: some View {
        NavigationStack (path:$viewModel.path){
            VStack(spacing: 0) {
                storeListHeader(viewModel: viewModel)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.registeredStores, id: \.id) { store in
                                StoreCard(viewModel:viewModel, store: store, isRegistered:true)
                            }

                            Rectangle()
                                .fill(.surface1)
                                .frame(maxWidth: .infinity,maxHeight: 4)

                            ForEach(viewModel.nonRegisteredStores, id: \.id) { store in
                                StoreCard(viewModel:viewModel,store: store, isRegistered:false)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .selectLocation:
                    SelectLocationView(viewModel:viewModel)
                case .searchStore:
                    SearchStoreView(viewModel:viewModel)
                default:
                    EmptyView()
                }
            }
        }
    }
}

private func storeListHeader(viewModel:StoreListViewModel)-> some View {
    HStack {
        Button(action: {
            viewModel.path.append(Route.selectLocation)
        }) {
            HStack(spacing: 4) {
                Text(
                    viewModel.selectedLocation?.name.components(separatedBy: ",").joined(separator: " ") ?? "지역 선택")
                    .fontStyle(.title1)
                    .foregroundStyle(.gray10)
                
                Image("arrow_down")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray10)
            }
        }
        
        Spacer()
        
        Button(action: {
            viewModel.path.append(Route.searchStore)
            
        }) {
            Image("search")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical,10)
    .background(.myWhite)
}
