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
            return getAllSender(messageas: bleManager.listOfMessage)
        }
        
    }
    
    var dataTypes : [String] {
        get {
            return getAllDataType(messageas: bleManager.listOfMessage)
        }
        
    }
    
    
    
    
    @State private var selectedsender = "senders"
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
    
    
    var chartData : [Double]!{
        get {
            if filterIsOn  {
                return recivedMessage.map{Double($0.getValue())!}
                
            }else{
                return []
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    var body: some View {
        
        
        
        
        
        VStack (spacing: 10) {
            
            
            
            Text("Real Time")
                .font(.largeTitle .bold())
                .frame( maxWidth: .infinity, alignment: .topLeading)
            
                
                if bleManager.isConnected{
                    
                    
                    Toggle("Filter", isOn: $filterIsOn)
                    
                    
                    if filterIsOn {
                        HStack {
                            Text("Sender:")
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Picker("Please choose a sender", selection: $selectedsender) {
                                ForEach(senders, id: \.self) {
                                    Text($0)
                                }
                            }.frame(alignment: .topLeading)
                            
                            
                            
                            
                        }
                        
                        HStack {
                            Text("Data type:")
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Picker("Please choose a Data type", selection: $selectedDataType) {
                                ForEach(dataTypes, id: \.self) {
                                    Text($0)
                                }
                            }.frame(alignment: .topLeading)
                            
                            
                        }
                        
                        
                        VStack{
                            
                            
                            BarChartView(data: chartData, colors: [Color.purple, Color.blue])
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    List(recivedMessage, id : \.self) { message in
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
                        }
                    }.frame(maxHeight: .infinity)
                        .cornerRadius(20)
                    
                    
                }else{
                    Text("Device not connected")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .foregroundColor(Color.red)
                    
                    
                }
            
            
        }.padding(10)
        
        
        
        
    }
}


struct MyDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RealTimeView()
                .previewInterfaceOrientation(.portrait)
            RealTimeView()
                .previewInterfaceOrientation(.portraitUpsideDown)
            RealTimeView()
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
