//
//  AdditionalLocationView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let finalLocationOnTapGesture: (String, String, String, Bool) -> Void
    
    @StateObject var vm: AdditionalLocationVM = AdditionalLocationVM()
    @State private var navNextView: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(isPresented: $isPresented, isNavigationUsed: false, title: "추가 위치")
                .padding(.top, 10)
            
            AdditionalLocationSavedListView(savedAddresses: vm.savedAddress, tempItems: vm.tempItems)
                .padding(.top, 20)
                .padding(.horizontal, 20)

            
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "plus.magnifyingglass")
                    .resizable()
                    .frame(width: 15, height: 15)
                
                Text("추가하기")
                    .fontSpoqaHanSansNeo(size: 15, weight: .medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 25)
            .onTapGesture {
                navNextView = true
            }
            
            Spacer()
        }
        .preferredColorScheme(.dark)
        .task {
            vm.additinalLocationViewTaskAction()
        }
        .navToNextView(
            isPresented: $navNextView,
            view: AdditionalLocationLocalityListView(
                isPresented: $isPresented,
                progress: $progress,
                subLocalityOnTapGesture: subLocalityOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationView(
        isPresented: .constant(true),
        progress: .constant(.none),
        subLocalityOnTapGesture: {_, _, _ in }
    )
}
