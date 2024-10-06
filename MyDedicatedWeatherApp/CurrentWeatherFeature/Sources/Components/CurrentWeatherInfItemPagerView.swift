//
//  CurrentWeatherInfItemPagerView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI
import SwiftUIPager
import Core

struct CurrentWeatherInfItemPagerView: View {
    
    @ObservedObject var viewModel: CurrentWeatherVM
    @Binding var pageIndex: Int
    let page: Page
    let isLoadCompleted: Bool
    
    @EnvironmentObject var contentVM: ContentVM
    @State private var pagerViewHeight: CGFloat = 0
    
    var body: some View {
        let pageIndexes: [Int] = [0, 1]
        
        Pager(page: page, data: pageIndexes, id: \.self) { index in
            
            switch index {
                
            case 0:
                currentWeatherInfPagerFirstView
                    .getHeight(height: $pagerViewHeight)
                
            case 1:
                currentWeatherInfPagerSecondView
                
            default:
                EmptyView()
                
            }
        }
        .onPageChanged { index in
            pageIndex = index
        }
        .frame(height: pagerViewHeight != 0 ? pagerViewHeight : nil)
        .loadingProgressLottie(isLoadingCompleted: isLoadCompleted, height: pagerViewHeight)
    }
}

struct CurrentWeatherInfItemPagerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInfItemPagerView(
            viewModel: CurrentWeatherVM(),
            pageIndex: .constant(1),
            page: .first(),
            isLoadCompleted: true
        )
    }
}

// MARK: - Supporint Views..

extension CurrentWeatherInfItemPagerView {
    
    /// 강수량, 바람, 습도 정보 view에는 loading animation 사용하지 않으므로 .constant(true)
    /// 미세먼지 정보 view에는 loading animation 사용하므로 바인딩
    var currentWeatherInfPagerFirstView: some View {
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                loadCompleted: true,
                imageString: "precipitation",
                imageColor: Color.blue,
                title: "강수량",
                value: viewModel.currentWeatherInformation.oneHourPrecipitation,
                isDayMode: contentVM.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                loadCompleted: true,
                imageString: "wind",
                imageColor: Color.red.opacity(0.7),
                title: "바람",
                value: viewModel.currentWeatherInformation.windSpeed,
                isDayMode: contentVM.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                loadCompleted: true,
                imageString: "wet",
                imageColor: Color.blue.opacity(0.7),
                title: "습도",
                value: viewModel.currentWeatherInformation.wetPercent,
                isDayMode: contentVM.isDayMode
            )
        }
        .padding(.horizontal, 26)
    }
}

extension CurrentWeatherInfItemPagerView {
    var currentWeatherInfPagerSecondView: some View {
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                loadCompleted: viewModel.isFineDustLoadCompleted,
                imageString: "fine_dust",
                imageColor: Color.black.opacity(0.7),
                title: "미세먼지",
                value: (viewModel.currentFineDustTuple.description, ""),
                isDayMode: contentVM.isDayMode,
                backgroundColor: viewModel.currentFineDustTuple.color
            )
            
            CurrentWeatherInformationItemView(
                loadCompleted: viewModel.isFineDustLoadCompleted,
                imageString: "fine_dust",
                imageColor: Color.red.opacity(0.7),
                title: "초미세먼지",
                value: (viewModel.currentUltraFineDustTuple.description, ""),
                isDayMode: contentVM.isDayMode,
                backgroundColor: viewModel.currentUltraFineDustTuple.color
            )
        }
        .padding(.horizontal, 26)
    }
}
