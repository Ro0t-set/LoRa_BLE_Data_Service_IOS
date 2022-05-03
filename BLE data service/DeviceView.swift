//
//  ContentView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI
import CoreBluetooth

struct DeviceView: View {
    
    
    
    @ObservedObject var bleManager = BLEManager.shared()
    @State private var sendGpsData = true

    
    
    
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
                    Text("Bluetooth is NOT switched on")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            
            
            
            
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
                    Text("None")
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
                            
                            Text("Start Scanning").padding(20).foregroundColor(Color.black).background(Color(UIColor.systemGreen)).cornerRadius(10)
                        }
                        
                    }else if (bleManager.isScanning &&  !bleManager.isConnected){
                        Button(action: {
                            
                            self.bleManager.stopScanning()
                            
                            
                        }) {
                            
                            Text("Stop Scanning").padding(20).foregroundColor(Color.black).background(Color(UIColor.systemRed)).cornerRadius(10)
                        }
                    }
                    
                    if bleManager.isConnected{
                        Toggle("Send position", isOn: $sendGpsData)
                        
                        
                        if sendGpsData {
                            Text("Hello World!")
                        }
                        
                    }
                }.padding()
                
                
            }
            Spacer()
            if bleManager.isConnected{
                Text("Log: \(self.bleManager.message)")
                
            }
            
            
            
            
        }.padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
        
    }
}
