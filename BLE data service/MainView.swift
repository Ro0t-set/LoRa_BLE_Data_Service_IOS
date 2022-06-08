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
    
    func getNotificationNumber(newDataCount : Int, oldDataCount: Int, tabName : String) -> Int{
        if selectedTab != tabName{
            if newDataCount + 1  < oldDataCount && self.bleManager.isConnected{
                return newDataCount
            }
            if  !self.bleManager.isConnected && (newDataCount - oldDataCount) < 0 || !self.bleManager.isConnected && newDataCount>0 && (newDataCount - oldDataCount) != 0{
                return newDataCount
            }
            return newDataCount - oldDataCount
            
        }
        return 0
    }
    
    
    var newData : Int {
        get{
            getNotificationNumber(newDataCount: self.bleManager.listOfMessage.count, oldDataCount: oldDataNumber, tabName: "data")
        }
    }
    
    
    var newGPSData : Int {
        get{
            getNotificationNumber(newDataCount: bleManager.messagefilterByDataType(dataType: "'GPS'").count, oldDataCount: oldGPSDataNumber, tabName: "map")
        }
    }
    
    
    
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        
        
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            
            DeviceView()
                .tabItem{
                    Label("Device", systemImage: "ferry")
                }.tag("device")
                .onAppear{
                    if self.bleManager.listOfMessage.count == 0{
                        self.oldDataNumber = 0
                        self.oldGPSDataNumber = 0
                    }
                }

            
            
            
            DataView()
                .tabItem{
                Label("Data", systemImage: "chart.bar.doc.horizontal")
                }
                .badge(self.newData)
                .tag("data")
                .onAppear{
                    self.oldDataNumber  =  bleManager.listOfMessage.count
                }
                .onDisappear{
                    self.oldDataNumber = bleManager.listOfMessage.count
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
                self.oldGPSDataNumber  =  bleManager.messagefilterByDataType(dataType: "'GPS'").count
            }
            .onDisappear{
                self.oldGPSDataNumber  =  bleManager.messagefilterByDataType(dataType: "'GPS'").count
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
