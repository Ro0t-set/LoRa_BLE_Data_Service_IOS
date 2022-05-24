//
//  MyDeviceView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI

struct RealTimeView: View {
    
    
    @ObservedObject var bleManager = BLEManager.shared()
    
    var senders : [String] {
        get {
            return ["None"] + getAllSender(messageas: bleManager.listOfMessage)
        }
        
    }
    
    var dataTypes : [String] {
        get {
            return ["None"] + getAllDataType(messageas: bleManager.listOfMessage)
        }
        
    }
    
    @State private var selectedsender = "None"
    @State private var selectedDataType = "None"
    @State private var filterIsOn = false
    
    
    var recivedMessage : [BLEData]! {
        get {
            if filterIsOn {
                return bleManager.messagefilterBySenderAndDataType(sender: selectedsender, dataType: selectedDataType)
                
            }else{
                return bleManager.listOfMessage
            }
        }
    }
    
    var chartData : [Double]? {
        get {
            return  recivedMessage.filter{
                if Double($0.getValue()) != nil{
                    return true
                    
                }else{
                    return false
                    
                }
                
            }.map{Double($0.getValue())!}
            
        }
    }
    
    var chartDate : [Date] {
        get {
            return recivedMessage.map{$0.currentDateTime}
        }
    }
    
    
    
    var body: some View {
        
        
        
        
        VStack (spacing: 10) {
            
            
            
            Text("Real Time")
                .font(.largeTitle .bold())
                .frame( maxWidth: .infinity, alignment: .topLeading)
                .padding()
            
            
            if bleManager.listOfMessage.count > 0{
                
                ScrollView {
                    VStack{
                        Toggle("Filter", isOn: $filterIsOn)
                        
                        
                        
                    }          .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(Color.white)
                        .cornerRadius(20)
                    
                    
                    
                    if filterIsOn {
                        VStack{
                            HStack {
                                Text("Sender:")
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Picker("Please choose a sender", selection: $selectedsender) {
                                    ForEach(senders, id: \.self) {
                                        Text($0)
                                    }
                                }.frame(alignment: .topLeading)
                                
                                
                                
                                
                            }.padding()
                            
                            
                            HStack {
                                Text("Data type:")
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Picker("Please choose a Data type", selection: $selectedDataType) {
                                    ForEach(dataTypes, id: \.self) {
                                        Text($0)
                                    }.padding()
                                }.frame(alignment: .topLeading).padding(5)
                                
                            }.padding()
                            
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        
                    }
                    Divider().background(Color.black)
                    
                    ScrollView{
                        ForEach(self.recivedMessage , id: \.self) { message in
                            VStack{
                                Text(message.sender)
                                    .font(.title3 .bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Text(message.getKey())
                                    Spacer()
                                    Text(String(message.getValue()))
                                    
                                }
                                
                                Text( message.getDataAsString())
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                                
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            
                            
                        }.padding()
                            .padding(.bottom, 70)
                        
                    }.frame(height: 350)
                    
                    Divider().background(Color.black)
                    
                    
                    
                    
                    VStack{
                        if (chartData?.count)! > 0 && filterIsOn{
                            BarChartView(data: chartData!, colors: [Color.purple, Color.blue])                             .frame(height: 300)
                            
                                .background(Color.white.cornerRadius(20))
                                .padding()
                            
                            Spacer()
                            
                            LineChartView(dataPoints: chartData!, date: chartDate)
                                .frame(height: 300)
                            
                                .background(Color.white.cornerRadius(20))
                                .padding()
                            
                        }
                    }.frame(maxHeight: 700)
                    
                    
                }.padding()
                
                
            }else{
                Text("Device not connected")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .foregroundColor(Color.red)
                    .padding(.horizontal)
                Text("Connect a device or import data").padding()
                
            }
            
        }
        
        .background(Color(UIColor.systemGroupedBackground))
        
        
        
        
    }
}


struct MyDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RealTimeView()
            
            
        }
    }
}
