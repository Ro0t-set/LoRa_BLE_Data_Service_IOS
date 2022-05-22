//
//  ContentView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI
import CoreBluetooth
import FilePicker
import CoreLocation
import CoreLocationUI

private let GPSTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

struct DeviceView: View {
    
    
    
    @ObservedObject var bleManager = BLEManager.shared()
    @State private var sendGpsData = true
    @State private var loadedFile = false
    
    
    @StateObject var locationManager = LocationManager()
    var timer = Timer()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    
    func sendGPSDataInBLE(){
        if sendGpsData{
            self.bleManager.whrite(messageString: "{GPS:\(userLongitude),\(userLongitude)}")
            
        }
    }
    
    
    var body: some View {
        VStack (spacing: 10) {
            
            Text("Devices")
                .font(.largeTitle .bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if self.loadedFile  {
                Text("File uploaded successfully")
                    .font(.caption .bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.green)
                
            }
            
            
            
            
            if !self.bleManager.isConnected {
                
                VStack{
                    
                    ForEach(bleManager.peripherals) { peripheral in
                        HStack {
                            Text(peripheral.name)
                                .padding(.horizontal, 30)
                                .font(.system(size: 45, weight: .bold, design: .default))
                            Spacer()
                            Text(String(peripheral.rssi))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 50)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .onTapGesture {
                            bleManager.connect(peripheral: peripheral.CBP)
                        }
                    }
                }.frame(maxHeight: .infinity, alignment: .top)
            }else{
                
                VStack{
                    HStack {
                        Text(self.bleManager.device.name!)
                            .padding(.horizontal, 30)
                            .font(.system(size: 45, weight: .bold, design: .default))
                        Spacer()
                        Toggle("Send position", isOn: $sendGpsData).padding()
                    }
                    
                    
                    if sendGpsData {
                        VStack {
                            Text("")
                                .onReceive(GPSTimer) { _ in
                                    if sendGpsData{
                                        self.bleManager.whrite(messageString: "{'GPS':\(userLatitude), \(userLongitude)}")
                                    }
                                }
                        }
                        
                    }
                    
                    Spacer()
                    HStack {
                        Text("Status")
                        Spacer()
                        Text("Connect")
                    }.padding()
                    Spacer()
                    HStack {
                        Text("Identifier")
                        Spacer()
                        Text("\(self.bleManager.device.identifier)")
                    }.padding()
                    
                    
                    Spacer()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }.frame(maxHeight:.infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 3)
                    .onTapGesture {
                        bleManager.connect(peripheral: self.bleManager.device)
                    }
            }
            
            Spacer()
            
            VStack (spacing: 10) {
                if (!bleManager.isConnected && !bleManager.isScanning){
                    GeometryReader { metrics in
                        HStack{
                            Button(action: {
                                self.bleManager.startScanning()
                                
                            }) {
                                
                                Text("Start Scanning")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .foregroundColor(Color.white)
                                    .background(Color(UIColor.systemBlue))
                                    .cornerRadius(10)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                
                                
                            }
                            
                            FilePicker(types: [.plainText], allowMultiple: false) { urls in
                                
                                
                                do {
                                    let text = try String(contentsOf:  urls[0].absoluteURL, encoding: .utf8)
                                    self.bleManager.dataLoading(data: text)
                                    if(self.bleManager.listOfMessage.count > 0){
                                        self.loadedFile = true
                                    }
                                    
                                }
                                catch {/* error handling here */}
                                
                            } label: {
                                
                                
                                Text("Log File")
                                    .frame(maxWidth: metrics.size.height * 0.53)
                                    .padding(.vertical, 15)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .foregroundColor(Color.white)
                                    .background(Color(UIColor.systemPurple))
                                    .cornerRadius(10)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                
                            }
                            
                        }
                        
                    }
                    
                }else if (bleManager.isScanning &&  !bleManager.isConnected){
                    Button(action: {
                        
                        self.bleManager.stopScanning()
                        
                        
                    }) {
                        
                        Text("Stop Scanning")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemRed))
                            .cornerRadius(10)
                        
                    }
                }else if (bleManager.isConnected){
                    Button(action: {
                        
                        self.bleManager.disconnect()
                        
                    }) {
                        
                        Text("Disconect")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemRed))
                            .cornerRadius(10)
                        
                    }
                }
            }
        }.padding(15)
            .background(Color(UIColor.systemGroupedBackground))
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            
            DeviceView()
            
            
            
            
            
        }
        
        
    }
}
