//
//  LogView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}


struct LogView: View {
    @ObservedObject var bleManager = BLEManager.shared()
    
    var logs : String {
        get{
            return   self.bleManager.listOfMessage.map{"\($0.getKey())\t\($0.getValue())\t\($0.getDataAsString())" }.joined(separator: "\n")
        }
    }
    
    
    @State private var isShareSheetPresented = false
    var body: some View {
        VStack{
            HStack{
                Text("Ble Log")
                    .font(.largeTitle .bold())
                    .frame( maxWidth: .infinity, alignment: .topLeading)
                    .padding()
                Button(action: {
                    self.isShareSheetPresented.toggle()
                }) {
                    
                    Image(systemName: "square.and.arrow.up")
                        .scaleEffect(1.5)
                        .padding(.horizontal)
                       
                        
                }.sheet(isPresented: $isShareSheetPresented) {
                    ShareSheetView(activityItems: [logs])
                }
                
            }
            ScrollView {
                Text(logs).font(.caption).padding()

                
            }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        
        
    }
}




struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
