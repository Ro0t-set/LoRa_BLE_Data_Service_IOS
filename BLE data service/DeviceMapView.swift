//
//  MapView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 04/05/22.
//

import SwiftUI
import MapKit


struct DeviceMapView: View {
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var bleManager = BLEManager.shared()
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var GPSData : [BLEData]{
        get{
            return bleManager.messagefilterByDataType(dataType: "GPS")
        }
        
    }
    
    func aroundOfBleData(date : Date, name : String) -> [BLEData]{
        
        return bleManager.listOfMessage
            .filter{
                Int($0.currentDateTime.timeIntervalSince1970) < Int(date.timeIntervalSince1970)
                &&
                Int($0.currentDateTime.addingTimeInterval(60).timeIntervalSince1970) > Int(date.timeIntervalSince1970)
            }
            .filter{ $0.getSender() == name}
        
    }
    
    var tempPlace : [Place] = [ ]
    
    var places : [Place]{
        get{
            let datas = bleManager.messagefilterByDataType(dataType: "'GPS'")
            
            self.locationManager.startUpdatingLocation()
            return [Place(name: "me", latitude: userLatitude, longitude: userLongitude, date: Date(), aroundOfBleData: nil)] +
            datas.map{
                Place(
                    name: $0.sender,
                    latitude:  Double($0.getValue().components(separatedBy: ",")[0]) ?? 0,
                    longitude :  Double($0.getValue().components(separatedBy: ",")[1]) ?? 0,
                    date :  $0.currentDateTime,
                    aroundOfBleData : self.aroundOfBleData( date: $0.currentDateTime, name: $0.sender)
                )
            }
        }
        
    }
    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
    
    var region : MKCoordinateRegion{
        get{
            return MKCoordinateRegion(
                
                center: CLLocationCoordinate2D(latitude: places.last?.latitude ?? 0, longitude: places.last?.longitude ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
            
        }
        
    }
    
    
    var body: some View {
        if(places.count > 0){
            MapView(places: places, region: region, info: places.last!)
            
        }else{
            Text("No data")
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceMapView()
    }
}


