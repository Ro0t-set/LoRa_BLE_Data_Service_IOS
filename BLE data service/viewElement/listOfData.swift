//
//  listOfData.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 05/06/22.
//

import SwiftUI

struct listOfData: View {
    var recivedMessage : [BLEData]
    var selectedsender : String = "None"
    var selectedDataType : String = "None"
    var body: some View {
        ScrollView{
            ForEach(self.recivedMessage , id: \.self) { message in
                
                VStack{
                    if self.selectedsender == "None"{
                        Text("Sender: \(message.sender)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                  
                        if self.selectedDataType == "None"{
                            Text("\(message.getKey()): \(message.getValue())")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }else{
                        
                        Text(String(message.getValue()))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        Spacer()
                    Text( message.getDataAsString())
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    
                }.padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 3)
                
                
            }.padding()
                .padding(.bottom, 70)
            
        }
        .frame(maxHeight: .infinity )
        .cornerRadius(20)
    }
    
}



