//
//  BarView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 03/05/22.
//

import SwiftUI

struct BarView: View {
    var datum: Double
    var colors: [Color]
    var descrition : String
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(gradient)
                .opacity(datum == 0.0 ? 0.0 : 1.0)
            
            Text(descrition).rotationEffect(.degrees(-90))
        }
        
    }
}
