//
//  CurrentWeatherInfItemPagerView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI
import SwiftUIPager

struct CurrentWeatherInfItemPagerView: View {
    
    @ObservedObject var viewModel: TodayViewModel
    @Binding var pageIndex: Int
    let page: Page
    
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
    }
}

struct CurrentWeatherInfItemPagerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInfItemPagerView(
            viewModel: TodayViewModel(),
            pageIndex: .constant(1),
            page: .first()
        )
    }
}

// MARK: - Supporint Views..

extension CurrentWeatherInfItemPagerView {
    var currentWeatherInfPagerFirstView: some View {
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                imageString: "precipitation2",
                imageColor: Color.blue,
                title: "강수량",
                value: viewModel.currentWeatherInformation.oneHourPrecipitation,
                isDayMode: viewModel.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                imageString: "wind2",
                imageColor: Color.red.opacity(0.7),
                title: "바람",
                value: viewModel.currentWeatherInformation.windSpeed,
                isDayMode: viewModel.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                imageString: "wet2",
                imageColor: Color.blue.opacity(0.7),
                title: "습도",
                value: viewModel.currentWeatherInformation.wetPercent,
                isDayMode: viewModel.isDayMode
            )
        }
        .padding(.horizontal, 26)
    }
}

extension CurrentWeatherInfItemPagerView {
    var currentWeatherInfPagerSecondView: some View {
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                imageString: "fine_dust",
                imageColor: Color.black.opacity(0.7),
                title: "미세먼지",
                value: (viewModel.currentFineDustTuple.description, ""),
                isDayMode: viewModel.isDayMode,
                backgroundColor: viewModel.currentFineDustTuple.color
            )
            
            CurrentWeatherInformationItemView(
                imageString: "fine_dust",
                imageColor: Color.red.opacity(0.7),
                title: "초미세먼지",
                value: (viewModel.currentUltraFineDustTuple.description, ""),
                isDayMode: viewModel.isDayMode,
                backgroundColor: viewModel.currentUltraFineDustTuple.color
            )
        }
        .padding(.horizontal, 26)
    }
}
