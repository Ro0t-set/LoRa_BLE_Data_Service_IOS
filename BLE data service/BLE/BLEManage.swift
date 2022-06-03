//
//  BLEManage.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 27/04/22.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let CBP: CBPeripheral
    
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var myCentral: CBCentralManager!
    @Published var peripherals = [Peripheral]()
    @Published var isSwitchedOn = false
    @Published var isConnected = false
    @Published var device : CBPeripheral!
    @Published var service = CBUUID(string: "36353433-3231-3039-3837-363534333231")
    @Published var descriptor : CBDescriptor!
    @Published var message = ""
    @Published var listOfMessage = [BLEData]()
    
    @Published var isScanning = false
    
    var characteristic: CBCharacteristic!
    
    
    
    
    
    
    override init() {
        super.init()
        
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
        
    }
    
    private static var bleManager: BLEManager = {
        let bleManager = BLEManager()
        return bleManager
        
    }()
    
    class func shared() -> BLEManager {
        return bleManager
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, CBP: peripheral)
        print(newPeripheral)
        peripherals.append(newPeripheral)
    }
    
    func startScanning() {
        print("startScanning")
        self.peripherals.removeAll()
        self.myCentral.scanForPeripherals(withServices: [service], options: nil)
        self.isScanning = true
        
    }
    
    func stopScanning() {
        myCentral.stopScan()
        self.isScanning = false
    }
    
    func connect(peripheral: CBPeripheral) {
        
        self.stopScanning()
        self.myCentral.connect(peripheral,  options: nil)
        self.isConnected = true
        self.device = peripheral
        self.device.delegate = self
        self.device.discoverServices([service])
        
        
        
    }
    
    func disconnect(){
        self.myCentral.cancelPeripheralConnection(self.device)
        self.device = nil
        self.isConnected = false
        
    }
    
    
    
    
    
    func whrite(messageString: String){
        let data = messageString.data(using: .utf8)!
        
        if self.characteristic != nil{
            device.writeValue(data, for: self.characteristic, type: .withResponse)
            
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // If an error occurred, disconnect so we can try again from the start
        if let error = error {
            print("Unable to discover services: \(error.localizedDescription)")
            
            return
        }
        
        // Specify the characteristic we want
        let characteristic = CBUUID(string: "36353433-3231-3039-3837-363534333231")
        
        // It's possible there may be more than one service,
        // so loop through each one to discover the one that we want
        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics([characteristic], for: service)
        }
    }
    
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // If an error occurred, disconnect so we can try again from the start
        if let error = error {
            print("Unable to discover characteristics: \(error.localizedDescription)")
            
            return
        }
        
        // Specify the characteristic we want
        let characteristicUUID = CBUUID(string: "36353433-3231-3039-3837-363534333231")
        
        // Perform a loop in case we received more than one characteristic
        service.characteristics?.forEach { characteristic in
            guard characteristic.uuid == characteristicUUID else { return }
            
            // Subscribe to this characteristic,
            // so we can be notified when data comes from it
            peripheral.setNotifyValue(true, for: characteristic)
            
            // Hold onto a reference for this characteristic for sending data
            self.characteristic = characteristic
        }
    }
    
    
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Perform any error handling if one occurred
        if let error = error {
            print("Characteristic value update failed: \(error.localizedDescription)")
            return
        }
        
        // Retrieve the data from the characteristic
        guard let data = characteristic.value else { return }
        
        // Decode/Parse the data here
        let message = String(decoding: data, as: UTF8.self)
        self.message = message
        self.listOfMessage.append(BLEData(data: message))
    }
    
    
    
    func getAllSender () -> [String]{
        return Array(Set(self.listOfMessage.map { $0.getSender() }))
    }
    
    func getAllDataType () -> [String]{
        return  Array(Set(self.listOfMessage.map { $0.getKey() }))
    }
    
    
    func messagefilterBySenderAndDataType (sender : String , dataType : String) -> [BLEData]{
        return  self.listOfMessage
            .filter { $0.getKey() == dataType ||  dataType == "None"}
            .filter { $0.getSender() == sender ||  sender == "None"}
    }
    
    func messagefilterByDataType (dataType : String) -> [BLEData]{
        return  self.listOfMessage.filter { $0.getKey() == dataType }
    }
    
    
    func aroundOfBleData(startDate : Date, endDate : Date) -> [BLEData]{
        
        return listOfMessage
            .filter{
                Int($0.currentDateTime.timeIntervalSince1970) < Int(startDate.timeIntervalSince1970)
                &&
                Int($0.currentDateTime.timeIntervalSince1970) > Int(endDate.timeIntervalSince1970)
            }
            
        
    }
    
    func dataLoading(data : String)  {
        let col : [String] = data.components(separatedBy: .newlines)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss E, d MMM y"
        var fileParser: [BLEData] =  [ ]
        
        fileParser = col.filter{
            $0.components(separatedBy: CharacterSet(["\t"])).count == 4
        }.map{
            BLEData(sender: $0.components(separatedBy: CharacterSet(["\t"]))[0],
                    key: $0.components(separatedBy: CharacterSet(["\t"]))[1],
                    value:  $0.components(separatedBy: CharacterSet(["\t"]))[2],
                    date: formatter.date(from: $0.components(separatedBy:CharacterSet(["\t"]))[3] ) ?? Date())
            
        }
        self.listOfMessage =  self.listOfMessage + fileParser
 
    }
    
    
    
    
    
    
    
    
    
    
}
