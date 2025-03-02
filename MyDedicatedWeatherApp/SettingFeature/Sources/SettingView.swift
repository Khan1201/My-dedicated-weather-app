//
//  SettingView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/1/23.
//

import SwiftUI
import Core
import Domain

public struct SettingView: View {
    
    @StateObject var vm: SettingVM = SettingVM()
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("설정")
                .fontSpoqaHanSansNeo(size: 30, weight: .bold)
                .foregroundStyle(Color.white)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(vm.menus.indices, id: \.self) { index in
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack(alignment: .center, spacing: 20)  {
                            Image(systemName: vm.images[index])
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.white)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(vm.menus[index])
                                    .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                                    .foregroundStyle(Color.white)

                                Text(vm.subTexts[index])
                                    .fontSpoqaHanSansNeo(size: 13, weight: .regular)
                                    .foregroundStyle(Color.white.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            if vm.showRightIcon(index) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 8, height: 10)
                                    .foregroundStyle(Color.white)
                                    .padding(.trailing, 14)
                            }
                        }
                        
                        if index != vm.menus.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 1.3)
                            
                        }
                    }
                    .onTapGesture {
                        vm.buttonTapGesture(index: index)
                    }
                }
            }
            .padding(.top, 50)
            
            Spacer()
        }
        .padding(.top, 35)
        .padding(.horizontal, 20)
        .background(Color.black)
        .sheet(isPresented: $vm.openMailView) {
            MailView(isPresented: $vm.openMailView)
        }
        .bottomNoticeFloater(
            isPresented: $vm.showMailOpenFailAlert,
            view: BottomNoticeFloaterView(
                title: "기본 메일(Mail)앱이 존재하지 않습니다."
            )
        )
        .navToNextView(
            isPresented: $vm.navOpenSourceView,
            view: OpenSourceListView(
                isPresented: $vm.navOpenSourceView,
                titles: vm.openSourceTitles,
                subTitles: vm.openSourceSubTitles,
                tapAvailableIndexes: vm.openSourceTapAvailableIndexes
            )
        )
        .navToNextView(
            isPresented: $vm.navWeatherStandardView,
            view: EmptyView()
        )
    }
}

#Preview {
    SettingView()
}
