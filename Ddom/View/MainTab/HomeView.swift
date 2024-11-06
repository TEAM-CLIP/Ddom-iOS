//
//  HomeView.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack{
            BackNavBar()
            Spacer()
            
            Text("HomeView")
            
            Spacer()
        }
        .padding(.horizontal,16)
        .toolbar(.hidden)
    }
}
