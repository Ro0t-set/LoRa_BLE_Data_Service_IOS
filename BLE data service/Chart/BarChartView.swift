//
//  BarChartView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 03/05/22.
//

import SwiftUI

struct BarChartView: View {
    var data: [Double]
    var colors: [Color]
    @State private var chartDimention = 10.0
    @State private var isEditing = false
    
    var highestData: Double {
        let max = data.max() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    HStack(alignment: .bottom, spacing: 4.0) {
                        
                        
                        
                        ForEach(data.indices, id: \.self) { index in
                            
                            let width = (geometry.size.width / CGFloat(chartDimention)) - 4.0
                            let height = geometry.size.height * data[index] / highestData
                            
                            BarView(datum: data[index], colors: colors, descrition: String( data[index]))
                                .frame(width: width, height: height, alignment: .bottom)
                        }
                    }
                    
                }
            }
            Slider(
                value: $chartDimention,
                in: 4...25,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            ).frame(maxWidth: 200, alignment: .center)
            
            
            
        }
    }
}
