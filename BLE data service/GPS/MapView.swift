//
//  MapView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 11/05/22.
//

import SwiftUI
import MapKit
import SlideOverCard

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let date: Date
    let aroundOfBleData: [BLEData]?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}

extension Place: Equatable {
    static func < (lhs: Place, rhs: Place) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.longitude == rhs.longitude && lhs.date == rhs.date
    }
}


struct MapView: View {
    
    
    
    let places : [Place]
    
    
    @State var region : MKCoordinateRegion
    @State var info : Place
    @State private var position = CardPosition.middle
    @State private var background = BackgroundStyle.blur
    
    var body: some View {
        
        
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    ZStack{
                        Circle()
                            .strokeBorder(Color(randomColor(seed: place.name)), lineWidth:5)
                            .frame(width: 20, height: 20)
                            .shadow(radius: 3)
                            .onTapGesture {
                                self.info = place
                                
                            }
                        
                        if  self.info == place{
                            Circle()
                                .strokeBorder(Color(randomColor(seed: place.name)), lineWidth:10)
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                }
                
            }.ignoresSafeArea()
            
            
            SlideOverCard($position, backgroundStyle: $background ) {
                VStack {
                    Text("Info").font(.title)
                    
                    VStack{
                        Text("Name: \(self.info.name)")
                            .frame( maxWidth: .infinity, alignment: .topLeading)
                            .padding()
                        Text("Deta: \(self.info.date)")
                            .frame( maxWidth: .infinity, alignment: .topLeading)
                            .padding()
                        
                    }.background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .padding()
                    
                    ScrollView{
                        ForEach(self.info.aroundOfBleData ?? [ ] , id: \.self) { singolDataArround in
                            
                            VStack{
                                Text(singolDataArround.sender)
                                    .font(.title3 .bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Text(singolDataArround.getKey())
                                    Spacer()
                                    Text(String(singolDataArround.getValue()))
                                    
                                }
                                
                                Text( singolDataArround.getDataAsString())
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                                
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            
                            
                        }.padding()
                            .padding(.bottom, 70)
                        
                    }
                    
                    
                }
                
            }
            
        }
        
    }
    
    
}




