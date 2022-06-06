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
    var sender : String = ""
    var dataType : String = ""
    
    
    var body: some View {
        if  chartBarData.count > 0{
            VStack{
                Divider()
                if self.sender != ""{
                    Text("Sender: \(self.sender)")
                        .frame( maxWidth: .infinity, alignment: .leading)
                }
                if self.dataType != ""{
                    Text("Sender: \(self.dataType)")
                        .frame( maxWidth: .infinity, alignment: .leading)
                }
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        
                        
                        BarChartView(data: chartBarData, colors: [Color.purple, Color.blue])
                            .frame(minWidth: 300, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                            .background(Color.white.cornerRadius(20))
                        
                        Divider()
                        
                        
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
                            .background(Color.white.cornerRadius(20))
                        
                        
                        
                        
                        
                        
                        Spacer()
                        Divider()
                    }
                    
                }
                Spacer()
            }
        }
        
    }
}
