//
//  LineView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 04/05/22.
//

import SwiftUI

struct LineView: View {
    var dataPoints: [Double]
    var date: [Date]
    var dilatation: Double
    
    var highestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    var xRelativeDelta : [Int]{
        return date.map{
            Int($0.timeIntervalSince1970) - Int(date.first!.timeIntervalSince1970)
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                
                let height = geometry.size.height
                HStack{
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
                        
                        for index in 1..<dataPoints.count {
                            path.addLine(to: CGPoint(
                                x: CGFloat(Double(xRelativeDelta[index]) * dilatation),
                                y: height * self.ratio(for: index)))
                        }
                    }
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                    
                }.frame(width: Double(xRelativeDelta[dataPoints.count-1]) * dilatation)
                
            }
        }
        .padding()
        
        
    }
    
    private func ratio(for index: Int) -> Double {
        1 - ( dataPoints[index] / highestPoint)
    }
}
