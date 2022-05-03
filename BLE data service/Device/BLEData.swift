//
//  Data.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 01/05/22.
//

import Foundation

class BLEData: NSObject, ObservableObject{
    
    var message : [String]
    var sender : String
    let currentDateTime = Date()
    

    
    init(data : String) {
        let dataArr : [String] = data.components(separatedBy: "=")
        
        let cleenData = dataArr[1]
            .replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        
        
        let cleenDataArr : [String] = cleenData.components(separatedBy: ":")
        
        self.message = cleenDataArr
        self.sender = dataArr[0]
        

    }
    
    
    
    func getKey() -> String {
        return message[0]
    }
    
    
    func getValue() -> String {
        return message[1]
    }
    
    func getSender() -> String {
        return sender
    }
    
    func getDataAsString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss E, d MMM y"
        return formatter.string(from: self.currentDateTime)
    }
    
}



