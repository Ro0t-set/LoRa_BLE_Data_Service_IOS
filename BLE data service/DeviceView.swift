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
    @State private var fileUrl : String = ""
    
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
                withAnimation{
                    VStack{
                        Label("File uploaded successfully", systemImage: "doc")
                            .font(.title3 .bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.green)
                            .padding()
                        
                        
                        
                        Text("""
                         From: \(self.bleManager.listOfMessage.first!.getDataAsString())
                         """)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(Color(UIColor.darkGray))
                        
                        Text("""
                         to: \(self.bleManager.listOfMessage.last!.getDataAsString())
                         """)
                        .frame(maxWidth: .infinity,  alignment: .leading)
                        .padding()
                        .foregroundColor(Color(UIColor.darkGray))
                        
                        Button(action: {
                            self.bleManager.listOfMessage = [ ]
                            self.loadedFile.toggle()
                        }) {
                            Text("Unlink file")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundColor(Color.white)
                                .background(Color(UIColor.systemRed))
                                .cornerRadius(10)
                            
                        }.padding()
                        
                        
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 3)
                    .frame(maxWidth: .infinity)
                }
                
            }
            
            
            
            
            if !self.bleManager.isConnected {
                if !self.loadedFile{
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
                    }.frame(maxHeight: .infinity, alignment: .top)}
            }else{
                
                VStack{
                    HStack {
                        Text(self.bleManager.device.name!)
                            .padding(.horizontal, 30)
                            .font(.system(size: 45, weight: .bold, design: .default))
                        Spacer()
                        Toggle("Send position", isOn: $sendGpsData).padding()
                            .foregroundColor(Color(UIColor.darkGray))
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
                            .foregroundColor(Color(UIColor.darkGray))
                        Spacer()
                        Text("Connect")
                            .foregroundColor(Color(UIColor.darkGray))
                    }.padding()
                    Spacer()
                    HStack {
                        Text("Identifier")
                            .foregroundColor(Color(UIColor.darkGray))
                        Spacer()
                        Text("\(self.bleManager.device.identifier)")
                            .foregroundColor(Color(UIColor.darkGray))
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
            
            VStack (spacing: 0) {
                if (!bleManager.isConnected && !bleManager.isScanning){
                    GeometryReader { metrics in
                        HStack{
                            Button(action: {
                                self.bleManager.startScanning()
                                
                            }) {
                                Text("Start Scanning")
                                    .frame(maxWidth: metrics.size.width * 0.55)
                                    .padding(.vertical, 15)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .foregroundColor(Color.white)
                                    .background(Color(UIColor.systemBlue))
                                    .cornerRadius(10)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .opacity(loadedFile ? 0.5 : 1)
                            }
                            
                            FilePicker(types: [.plainText], allowMultiple: false) { urls in
                                
                                
                                do {
                                    let text = try String(contentsOf:  urls[0].absoluteURL, encoding: .utf8)
                                    self.fileUrl = try String(contentsOf: urls[0])
                                    self.bleManager.dataLoading(data: text)
                                    if(self.bleManager.listOfMessage.count > 0){
                                        self.loadedFile.toggle()
                                    }
                                    
                                }
                                catch {/* error handling here */}
                                
                            } label: {
                                
                                
                                Label("Load file", systemImage: "doc")
                                    .frame(maxWidth: metrics.size.width * 0.45)
                                    .padding(.vertical, 15)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .foregroundColor(Color.white)
                                    .background(Color(UIColor.systemPurple))
                                    .cornerRadius(10)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .opacity(loadedFile ? 0.5 : 1)
                                
                            }
                            
                        }
                        
                    }
                    .disabled(loadedFile)
                    .frame(maxHeight : 70)
                    
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
                        self.bleManager.listOfMessage = [ ]
                        
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
        }
        .padding(15)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            
            DeviceView()
            
            
            
            
            
        }
        
        
    }
}
