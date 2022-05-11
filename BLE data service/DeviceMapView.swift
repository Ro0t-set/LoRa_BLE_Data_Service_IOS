//
//  MapView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 04/05/22.
//

import SwiftUI
import MapKit


struct DeviceMapView: View {

    let places = [
        Place(name: "British Museum", latitude: 51.519581, longitude: -0.127002),
        Place(name: "Tower of London", latitude: 51.508052, longitude: -0.076035),
        Place(name: "Big Ben", latitude: 51.500710, longitude: -0.124617)
    ]
    

    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.514134, longitude: -0.104236),
        span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
    
    
    var body: some View {
        MapView(places: places, region: region)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceMapView()
    }
}


