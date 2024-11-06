//
//  SelectLocationView.swift
//  Ddom
//
//  Created by Neoself on 11/1/24.
//
import SwiftUI

struct SelectLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: StoreListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            BackNavBar()
            
            VStack{
                Text("또옴 가게 지역 선택")
                    .fontStyle(.heading2)
                    .foregroundStyle(.gray10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                
                VStack{
                    ForEach(viewModel.zones, id:\.self) { zone in
                        locationItem(zone)
                    }
                }
                
                Spacer()
                
                CustomButton(
                    action: {
                        dismiss() },
                    isPrimary: false,
                    isLoading: false,
                    text: "선택 완료하기",
                    isDisabled: false,
                    isFullWidth: true
                )
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
        }
        .toolbar(.hidden)

    }
    
    private func locationItem(_ zone:Zone) -> some View {
        Button(action: {
            viewModel.selectLocation(zone)
        }) {
            HStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text(zone.name.components(separatedBy: ",").joined(separator: "/"))
                        .fontStyle(.body3)
                        .foregroundStyle(.gray10)
                    
                    Text(viewModel.description[zone.name] ?? "세부설명 없음")
                        .fontStyle(.body5)
                        .foregroundStyle(.gray5)
                }
                
                Spacer()
                
                if viewModel.selectedLocation == zone {
                    Image("check")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray5)                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
            .fill(viewModel.selectedLocation == zone ? .surface1 : .clear)
        )
    }
}

#Preview{
    SelectLocationView(viewModel: StoreListViewModel())
}
