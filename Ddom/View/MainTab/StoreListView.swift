// StoreListView.swift
import SwiftUI

struct StoreListView: View {
    @EnvironmentObject var appState :AppState
    @StateObject private var viewModel: StoreListViewModel
    
    init(viewModel: StoreListViewModel = StoreListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack (path:$viewModel.path){
            
            ZStack {
                VStack(spacing: 0) {
                    storeListHeader(viewModel: viewModel)
                        .padding(.bottom,16)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.registeredStores, id: \.id) { store in
                                    StoreCard(
                                        viewModel:viewModel,
                                        store: store,
                                        isRegistered:true,
                                        onHeartClick: {
                                            appState.currentPopup = .storeRegister(
                                                name:store.storeName,
                                                action: {viewModel.registerStore(store.id)}
                                            )
                                        },
                                        onCardClick: {viewModel.selectStore(store.id)}
                                    )
                                }
                            }
                            
                            Rectangle()
                                .fill(.surface1)
                                .frame(maxWidth: .infinity,maxHeight: 4)
                            
                            ForEach(viewModel.nonRegisteredStores, id: \.id) { store in
                                StoreCard(
                                    viewModel:viewModel,
                                    store: store,
                                    isRegistered:false,
                                    onHeartClick: {print("nonregistered")},
                                    onCardClick: {viewModel.selectStore(store.id)}
                                )
                            }
                        }
                        .refreshable { viewModel.getStores() }
                    }
                }
            }
        }
        .background(.white)
        
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
                .foregroundStyle(.gray10)
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical,10)
    .background(.myWhite)
}

#Preview("Default") {
    StoreListView(viewModel: .mockViewModel())
        .environmentObject(AppState())
}

//StoreListView(viewModel: .mockViewModel(delaySeconds: 2))
//StoreListView(viewModel: .mockViewModel(shouldFail: true))
