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
        UITabBar.appearance().backgroundColor = UIColor.white
        
    }
    
    var body: some View {
        TabView{
            
            DeviceView()
                .tabItem{
                    Label("Device", systemImage: "ferry")
                }
            DataView().tabItem{
                Label("Data", systemImage: "chart.bar.doc.horizontal")
            }
            DeviceMapView().tabItem{
                Label("Map", systemImage: "map")
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
