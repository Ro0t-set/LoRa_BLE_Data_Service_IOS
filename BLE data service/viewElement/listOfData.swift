//
//  listOfData.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 05/06/22.
//

import SwiftUI

struct listOfData: View {
    var recivedMessage : [BLEData]
    var selectedsender : String
    var selectedDataType : String
    var body: some View {
        ScrollView{
            ForEach(self.recivedMessage , id: \.self) { message in
                
                VStack{
                    if self.selectedsender == "None"{
                        Text(message.sender)
                            .font(.title3 .bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    HStack {
                        if self.selectedDataType == "None"{
                            Text("\(message.getKey()): ")
                            
                            
                            Spacer()
                        }
                        
                        Text(String(message.getValue()))
                            .frame(alignment: .leading)
                        
                        
                        if self.selectedDataType != "None"{
                            Spacer()
                        }
                        
                    }
                    
                    Text( message.getDataAsString())
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    
                }.padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                
                
            }.padding()
                .padding(.bottom, 70)
            
        }
        .frame(maxHeight: .infinity )
        .background(Color.white)
        .cornerRadius(20)
    }
    
}



