//
//  LineChartCircleView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 04/05/22.
//

import SwiftUI

struct LineChartCircleView: View {
    var dataPoints: [Double]
    var radius: CGFloat
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
            let height = geometry.size.height
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))
                
                path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                            radius: radius, startAngle: .zero,
                            endAngle: .degrees(360.0), clockwise: false)
                
                for index in 1..<dataPoints.count {
                    path.move(to: CGPoint(
                        x: CGFloat(Double(xRelativeDelta[index]) * dilatation),
                        y: height * dataPoints[index] / highestPoint))
                    
                 
                    
                    path.addArc(center: CGPoint(
                        x: CGFloat(Double(xRelativeDelta[index]) * dilatation),
                        y: height * self.ratio(for: index)),
                                radius: radius, startAngle: .zero,
                                endAngle: .degrees(360.0), clockwise: false)
                }
            }
            .stroke(Color.accentColor, lineWidth: 2)
        }
        .padding(.vertical)
    }
    
    private func ratio(for index: Int) -> Double {
        1 - ( dataPoints[index] / highestPoint)
    }
}
