//
//  Filter.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 02/05/22.
//

import Foundation

func getAllSender (messageas: [BLEData]) -> [String]{
    return Array(Set(messageas.map { $0.getSender() }))
}

func getAllDataType (messageas: [BLEData]) -> [String]{
    return  Array(Set(messageas.map { $0.getKey() }))
}


func filterByDataType (messageas: [BLEData], dataType : String) -> [BLEData]{
    return  messageas.filter { $0.getKey() == dataType }
}


func filterBySender (messageas: [BLEData], sender : String) -> [BLEData]{
    return  messageas.filter { $0.getSender() == sender }
}


