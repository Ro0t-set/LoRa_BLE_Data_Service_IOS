//
//  MainView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI


struct MainView: View {
    @ObservedObject var bleManager = BLEManager.shared()
    @State private var selectedTab = "device"
    
    @State private var oldDataNumber : Int = 0
    @State private var oldGPSDataNumber : Int = 0
    
    
    
    var newData : Int {
        get{
            return bleManager.listOfMessage.count - oldDataNumber
        }
    }
    
    
    var newGPSData : Int {
        get{
            return bleManager.messagefilterByDataType(dataType: "'GPS'").count - oldGPSDataNumber
        }
    }
    
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        
        if bleManager.listOfMessage.count == 0{
            oldDataNumber = 0
            oldGPSDataNumber = 0
        }
        
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            
            DeviceView()
                .tabItem{
                    Label("Device", systemImage: "ferry")
                }.tag("device")
            
            
            
            DataView()
                .tabItem{
                Label("Data", systemImage: "chart.bar.doc.horizontal")
            }
                .badge(self.newData)
                .tag("data")
                .onAppear{
                    if selectedTab == "data"{
                        oldDataNumber  =  bleManager.listOfMessage.count
                    }
                }
                
            
            ChartView().tabItem{
                Label("Charts", systemImage: "chart.bar.xaxis")
            }
            .tag("charts")
            
            
            DeviceMapView().tabItem{
                Label("Map", systemImage: "map")
            }
            .tag("map")
            .badge(newGPSData)
            .onAppear{
                if selectedTab == "map"{
                    oldGPSDataNumber  =  bleManager.messagefilterByDataType(dataType: "'GPS'").count
                }
            }
            
            
            LogView().tabItem{
                Label("Log", systemImage: "doc")
            }
            .tag("log")
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        


    }
}
