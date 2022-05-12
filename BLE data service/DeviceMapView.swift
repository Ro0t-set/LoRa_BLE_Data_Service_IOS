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
    
    var tempPlace : [Place] = [ ]
    
    var places : [Place]{
        get{
            let datas = bleManager.messagefilterByDataType(dataType: "'GPS'")

            return [Place(name: "me now", latitude: userLatitude, longitude: userLongitude, date: Date())] + datas.map{
                Place(
                    name: $0.sender,
                    latitude:  Double($0.getValue().components(separatedBy: ",")[0]) ?? 0,
                    longitude :  Double($0.getValue().components(separatedBy: ",")[1]) ?? 0,
                    date :  $0.currentDateTime
                    
                )
            }
        }
        
    }
    
    
    var region : MKCoordinateRegion{
        get{
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude),
                span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
            
        }
        
    }
    
    
    var body: some View {
        MapView(places: places, region: region, info: places.last!)
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceMapView()
    }
}


