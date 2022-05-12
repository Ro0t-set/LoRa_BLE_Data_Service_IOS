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
    let date: Date
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    
    let places : [Place]
    
    @State var region : MKCoordinateRegion
    @State var info : Place
    
    
    var body: some View {
        VStack{
            Map(coordinateRegion: $region, annotationItems: places) { place in
                
                MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Circle()
                        .strokeBorder(Color(randomColor(seed: place.name)), lineWidth:10)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            self.info = place
                        }
                    
                }
                
            }
            
            Text(info.name)
            Text(info.date.formatted())
            
        }
        
        
        
    }
}




