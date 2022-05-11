//
//  ContentView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI
import CoreBluetooth

import CoreLocation
import CoreLocationUI

private let GPSTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

struct DeviceView: View {
    
    
    
    @ObservedObject var bleManager = BLEManager.shared()
    @State private var sendGpsData = false
    
    
    
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
            self.bleManager.whrite(messageString: "{GPS:\(userLongitude), \(userLongitude)}")
            
        }
    }
    
    
    var body: some View {
        VStack (spacing: 10) {
            
            Text("Devices")
                .font(.largeTitle .bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Text("BLE Status: ")
                    .font(.headline)
                    .frame(alignment: .leading)
                
                // Status goes here
                if bleManager.isSwitchedOn {
                    Text("Bluetooth is switched on")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                else {
                    Text("Bluetooth is not switched on")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            
            
            VStack{
            
            
            List(bleManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                    
                }.contentShape(Rectangle())
                    .onTapGesture {
                        
                        bleManager.connect(peripheral: peripheral.CBP)
                        
                    }.listRowBackground(self.bleManager.isConnected ? Color.green : nil)
                
                
            }.frame(height: 150)
                .cornerRadius(20)
            
            Text("select the device")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                
            }
            
            Spacer()
            
            HStack{

                
                Text("Device status: ")
                    .font(.headline)
                    .frame(alignment: .leading)
                
                // Status goes here
                if bleManager.isConnected {
                    Text("Connected")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        self.bleManager.disconnect()
                    }){
                        Text("Disconnect")
                            .padding(10)
                            .background(Color.red)
                            .foregroundColor(Color.black)
                            .cornerRadius(5)
                        
                    }
                }
                else {
                    Text("disconnect")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
            }.frame( alignment: .leading)
            
            Spacer()
            
            HStack {
                VStack (spacing: 10) {
                    if (!bleManager.isConnected && !bleManager.isScanning){
                        Button(action: {
                            self.bleManager.startScanning()
                            
                        }) {
                            
                            Text("Start Scanning").padding(15).foregroundColor(Color.black).background(Color(UIColor.systemGreen)).cornerRadius(10).frame( maxHeight: .infinity)
                        }
                        
                    }else if (bleManager.isScanning &&  !bleManager.isConnected){
                        Button(action: {
                            
                            self.bleManager.stopScanning()
                            
                            
                        }) {
                            
                            Text("Stop Scanning").padding(15).foregroundColor(Color.black).background(Color(UIColor.systemRed)).cornerRadius(10).frame( maxHeight: .infinity)
                        }
                    }
                    
                    if bleManager.isConnected{
                        Toggle("Send position", isOn: $sendGpsData)
                        if sendGpsData {
                            VStack {
                                Text("latitude: \(userLatitude)")
                                Text("longitude: \(userLongitude)")
                                    .onReceive(GPSTimer) { _ in
                                        if sendGpsData{
                                            self.bleManager.whrite(messageString: "{GPS:\(userLatitude), \(userLongitude)}")
                                            
                                        }
                                }
                        
                            }
                            
                        }
                        
                    }
                }.padding()
                
                
                
                
                
                
                
            }.padding(10)
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            
            DeviceView()
                .padding(.horizontal, 10)
            
            
            
            
        }
        
        
    }
}
