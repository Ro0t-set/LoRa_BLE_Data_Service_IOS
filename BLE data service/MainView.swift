//
//  MainView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI


struct MainView: View {
    @ObservedObject var bleManager = BLEManager.shared()
    
    init() {
        self.bleManager.startScanning()
        
        
    }
    
    var body: some View {
        TabView{
            DeviceView()
                .tabItem{
                    Label("Device", systemImage: "ferry")
                }
            RealTimeView().tabItem{
                Label("Real Time", systemImage: "arrow.triangle.2.circlepath.circle")
            }
            LogView().tabItem{
                Label("Log", systemImage: "doc")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        


    }
}
