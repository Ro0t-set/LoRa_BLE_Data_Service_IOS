//
//  MapView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 11/05/22.
//

import SwiftUI
import MapKit


struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {

    let places : [Place]

    @State var region : MKCoordinateRegion
    
    
    var body: some View {
        // 3.
        Map(coordinateRegion: $region, annotationItems: places) { place in
            
            MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                Circle()
                    .strokeBorder(Color.red, lineWidth:10)
                    .frame(width: 20, height: 20)
                
            }
        }
        
        
    }
}




