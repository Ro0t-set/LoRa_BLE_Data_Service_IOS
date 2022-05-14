//
//  LineChartView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 04/05/22.
//

import SwiftUI

struct LineChartView: View {
    var dataPoints: [Double]
    var date: [Date]
    var lineColor: Color = .red
    var outerCircleColor: Color = .red
    var innerCircleColor: Color = .red
    
    @State private var chartDimention = 1.0
    @State private var isEditing = false
    
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ZStack {
                    
                    LineView(dataPoints: dataPoints, date: date, dilatation: chartDimention)
                        .accentColor(lineColor)
                    
                   // LineChartCircleView(dataPoints: dataPoints,radius: 3.0,date:date, dilatation: chartDimention)
                        .accentColor(outerCircleColor)
                    
                    //LineChartCircleView(dataPoints: dataPoints, radius: 2.0, date: date, dilatation: chartDimention)
                        .accentColor(innerCircleColor)
                }
                
            }.padding()
            Slider(
                value: $chartDimention,
                in: 0.2...5,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            ).frame(maxWidth: 200, alignment: .center)
            
        }
    }
}

