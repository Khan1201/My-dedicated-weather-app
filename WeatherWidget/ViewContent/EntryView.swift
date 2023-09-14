//
//  EntryView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//


import SwiftUI

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        switch family {
            
        case .systemSmall:
            
            ZStack {
                Color.init(hexCode: "#000080")
                    .opacity(0.3)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .padding(.leading, 6)
                        
                        Text("서울특별시")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color.white)
                            .padding(.top, 3)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Updated")
                            Text(entry.date, style: .time)
                        }
                        .font(.system(size: 7, weight: .regular))
                        .foregroundColor(Color.white)
                        .padding(.top, 2)
                        .padding(.trailing, 12)
                    }
                    .padding(.leading, 10)
                    
                    HStack(alignment: .center, spacing: 15) {
                        Image("weather_rain")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading, 15)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("26°")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color.white)
                            
                            HStack(alignment: .bottom, spacing: 0) {
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color.blue.opacity(0.6))
                                
                                Text("26°")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(Color.white)
                                    .padding(.leading, 2)
                                                    
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color.red.opacity(0.6))
                                    .padding(.leading, 5)
                                
                                Text("30°")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(Color.white)
                                    .padding(.leading, 2)
                            }
                        }
                    }
                    .padding(.top, 3)
                    .padding(.leading, 8)
                    
                    HStack(alignment: .center, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: 10) {
                                Image("precipitation")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue.opacity(0.5))
                                    .frame(width: 15, height: 15)
                                
                                Text("비 없음")
                                    .font(.system(size: 9, weight: .medium))
                            }
                            
                            HStack(alignment: .center, spacing: 10) {
                                Image("wind")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.red.opacity(0.5))
                                    .frame(width: 15, height: 15)
                                
                                Text("약한 바람")
                                    .font(.system(size: 9, weight: .medium))
                            }
                            .padding(.top, 5)
                            
                            HStack(alignment: .center, spacing: 10) {
                                Image("wet")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue.opacity(0.3))
                                    .frame(width: 15, height: 15)
                                
                                Text("50%")
                                    .font(.system(size: 9, weight: .medium))
                            }
                            .padding(.top, 5)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.leading, 10)
                        
                        VStack(alignment: .center, spacing: 10) {
                            HStack(alignment: .center, spacing: 8) {
                                Image("fine_dust")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray)
                                    .frame(width: 16, height: 16)
                                
                                Text("좋음")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 1)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                                                        
                            HStack(alignment: .center, spacing: 8) {
                                Image("fine_dust")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.red.opacity(0.5))
                                    .frame(width: 16, height: 16)
                                
                                Text("좋음")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 1)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        case .systemMedium:
            
            ZStack {
                Color.init(hexCode: "#000080")
                    .opacity(0.3)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 6)
                                
                                Text("서울특별시")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 3)
                                    .padding(.leading, 4)
                                
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Updated")
                                    Text(entry.date, style: .time)
                                }
                                .font(.system(size: 8))
                                .padding(.leading, 10)
                                .padding(.top, 2)
                            }
                            .padding(.leading, 10)
                            
                            HStack(alignment: .bottom, spacing: 15) {
                                Image("weather_rain")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("26°")
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundColor(Color.white)
                                    
                                    HStack(alignment: .bottom, spacing: 0) {
                                        Image(systemName: "arrow.down")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.blue.opacity(0.6))
                                        
                                        Text("26°")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 2)
                                                            
                                        Image(systemName: "arrow.up")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.red.opacity(0.6))
                                            .padding(.leading, 5)
                                        
                                        Text("30°")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 2)
                                    }
                                }
                            }
                            .padding(.top, 5)
                        }
                        
                        Rectangle()
                            .frame(width: 1, height: 65)
                            .foregroundColor(Color.white.opacity(0.7))
                            .padding(.horizontal, 15)
                            .padding(.top, 10)
                        
                        HStack(alignment: .center, spacing: 10) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image("precipitation")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.blue.opacity(0.5))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("비 없음")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                
                                HStack(alignment: .center, spacing: 10) {
                                    Image("wind")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.red.opacity(0.5))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("약한 바람")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                .padding(.top, 5)
                                
                                HStack(alignment: .center, spacing: 10) {
                                    Image("wet")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.blue.opacity(0.3))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("50%")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                .padding(.top, 5)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 8) {
                                    Image("fine_dust")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.gray)
                                        .frame(width: 16, height: 16)
                                    
                                    Text("좋음")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(Color.white)
                                        .padding(.top, 1)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                                                            
                                HStack(alignment: .center, spacing: 8) {
                                    Image("fine_dust")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.red.opacity(0.5))
                                        .frame(width: 16, height: 16)
                                    
                                    Text("좋음")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(Color.white)
                                        .padding(.top, 1)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 7)
                    }
                    
                    HStack(alignment: .center, spacing: 25) {
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
        case .systemLarge:
            ZStack {
                Color.init(hexCode: "#000080")
                    .opacity(0.3)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 6)
                                
                                Text("서울특별시")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 3)
                                    .padding(.leading, 4)
                                
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Updated")
                                    Text(entry.date, style: .time)
                                }
                                .font(.system(size: 8))
                                .padding(.leading, 10)
                                .padding(.top, 2)
                            }
                            .padding(.leading, 10)
                            
                            HStack(alignment: .bottom, spacing: 15) {
                                Image("weather_rain")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("26°")
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundColor(Color.white)
                                    
                                    HStack(alignment: .bottom, spacing: 0) {
                                        Image(systemName: "arrow.down")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.blue.opacity(0.6))
                                        
                                        Text("26°")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 2)
                                                            
                                        Image(systemName: "arrow.up")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.red.opacity(0.6))
                                            .padding(.leading, 5)
                                        
                                        Text("30°")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 2)
                                    }
                                }
                            }
                            .padding(.top, 5)
                        }
                        
                        Rectangle()
                            .frame(width: 1, height: 65)
                            .foregroundColor(Color.white.opacity(0.7))
                            .padding(.horizontal, 15)
                            .padding(.top, 10)
                        
                        HStack(alignment: .center, spacing: 10) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image("precipitation")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.blue.opacity(0.5))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("비 없음")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                
                                HStack(alignment: .center, spacing: 10) {
                                    Image("wind")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.red.opacity(0.5))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("약한 바람")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                .padding(.top, 5)
                                
                                HStack(alignment: .center, spacing: 10) {
                                    Image("wet")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.blue.opacity(0.3))
                                        .frame(width: 15, height: 15)
                                    
                                    Text("50%")
                                        .font(.system(size: 9, weight: .medium))
                                }
                                .padding(.top, 5)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 8) {
                                    Image("fine_dust")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.gray)
                                        .frame(width: 16, height: 16)
                                    
                                    Text("좋음")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(Color.white)
                                        .padding(.top, 1)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                                                            
                                HStack(alignment: .center, spacing: 8) {
                                    Image("fine_dust")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.red.opacity(0.5))
                                        .frame(width: 16, height: 16)
                                    
                                    Text("좋음")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(Color.white)
                                        .padding(.top, 1)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 7)
                    }
                    
                    HStack(alignment: .center, spacing: 25) {
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("11PM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Image("weather_sunny_night")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("23°")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.leading, 2)
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: 0.7, alignment: .center)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                    
                    VStack(alignment: .center, spacing: 0) {
                        LineChartView(weeklyChartInformation: .constant(Dummy.weeklyChartInformation()))
                            .frame(width: 260, height: 130)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
//                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        case .systemExtraLarge:
            EmptyView()

        case .accessoryCircular:
            EmptyView()

        case .accessoryRectangular:
            EmptyView()

        case .accessoryInline:
            EmptyView()

        @unknown default:
            EmptyView()
        }
        
    }
    
}
