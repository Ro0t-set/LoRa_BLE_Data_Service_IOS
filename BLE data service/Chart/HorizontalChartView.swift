//
//  HorizontalChartView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 06/06/22.
//

import SwiftUI
import SwiftUICharts

struct HorizontalChartView: View {
    var chartBarData : [Double]
    var lineChartdata : LineChartData
    var sender : String = "test"
    var dataType : String = "wererwerw"
    
    
    var body: some View {
        if  chartBarData.count > 0{
            VStack{
                Divider()
                
                Text("Sender: \(self.sender)")
                Text("Sender: \(self.dataType)")
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        
                        GeometryReader { geometry in
                            
                            BarChartView(data: chartBarData, colors: [Color.purple, Color.blue])
                                .frame(minWidth: 300, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                                .background(Color.white.cornerRadius(20))
                            
                        }
                        
                        
                        .frame(width: 300, height: 300)
                        Divider()
                        GeometryReader { geometry in
                            
                            VStack{
                                LineChart(chartData: lineChartdata)
                                    .pointMarkers(chartData: lineChartdata)
                                    .touchOverlay(chartData: lineChartdata, specifier: "%d")
                                    .floatingInfoBox(chartData: lineChartdata)
                                    .xAxisGrid(chartData: lineChartdata)
                                    .yAxisGrid(chartData: lineChartdata)
                                    .xAxisLabels(chartData: lineChartdata)
                                    .yAxisLabels(chartData: lineChartdata)
                                    .infoBox(chartData: lineChartdata)
                                    .headerBox(chartData: lineChartdata)
                                    .legends(chartData: lineChartdata)
                                    .id(lineChartdata.id)
                                    .frame(minWidth: 300, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                                    .padding()
                            }
                            
                            
                        }
                        .background(Color.white.cornerRadius(20))
                        .frame(width: 300, height: 300)
                        
                        
                        Spacer()
                        Divider()
                    }
                    
                }
                
            }
        }
        
    }
}
