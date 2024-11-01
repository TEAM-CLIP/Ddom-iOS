import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var selectedTab = 1
    @State private var isToastPresented = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch(selectedTab) {
                case 0:
                    HomeView()
                default:
                    StoreListView()
                }
                BottomTab(selectedTab: $selectedTab)
            }
            .background(.myWhite)
            
            if isToastPresented, let toast = appState.currentToast {
                CustomToast(toastData: toast)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 40)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .move(edge: .top))
                    ))
                    .animation(.mediumEaseInOut, value: isToastPresented)
            }
        }
        .onChange(of: appState.currentToast?.text) { _, newValue in
            if newValue != nil {
                withAnimation {
                    isToastPresented = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isToastPresented = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appState.currentToast = nil
                    }
                }
            }
        }
    }
}

struct BottomTab: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        let tabBarText = [("gearshape.fill","홈"), ("magnifyingglass","가게 탐색")]
        
        ZStack {
            Rectangle()
                .fill(.myWhite)
                .shadow(color: .gray5.opacity(0.08), radius: 8)
            
            HStack(spacing: 0) {
                ForEach(0..<2, id: \.self) { index in
                    TabBarButton(
                        icon: tabBarText[index].0,
                        text: tabBarText[index].1,
                        isSelected: selectedTab == index
                    ) {
                        withAnimation(.fastEaseInOut) {
                            selectedTab = index
                        }
                        
                    }
                }
            }
            .background(.myWhite)
        }
        .frame(height: 56)
    }
}

struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName:icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width:24,height: 24)
                    .foregroundColor(isSelected ? .primary9 : .gray3)
                    .fontStyle(.body4)
                    
                Text(text)
                    .fontStyle(.caption1)
                    .foregroundColor(isSelected ? .primary9 : .gray5)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
        }
    }
}



#Preview {
    MainTabView()
        .environmentObject(AppState.shared)
}
