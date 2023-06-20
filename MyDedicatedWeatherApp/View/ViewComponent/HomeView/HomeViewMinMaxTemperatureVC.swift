//
//  HomeViewMinMaxTemperatureVC.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/01.
//

import SwiftUI

struct HomeViewMinMaxTemperatureVC: View {
    
    let day: Int
    let min: Int
    let max: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("\(day)일후")
                .font(.system(size: 20, weight: .semibold))
            
            Rectangle()
                .frame(width: 110, height: 1)
                .foregroundColor(Color.gray)
                .padding(.vertical, 10)
            
            HStack(alignment: .center, spacing: 5) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "arrow.down.left.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(min.description)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Rectangle()
                    .frame(width: 40, height: 1)
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90))
                
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "arrow.up.forward.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(max.description)
                        .font(.system(size: 18, weight: .medium))
                }
                
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(.black)
        }
    }
}

struct HomeViewMinMaxTemperatureVC_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewMinMaxTemperatureVC(
            day: 3,
            min: 25,
            max: 29
        )
    }
}
