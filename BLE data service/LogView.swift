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
    @State var isAnimating: Bool = false
    var logs : String {
        get{
            return   self.bleManager.listOfMessage.map{"\($0.getSender())\t\($0.getKey())\t\($0.getValue())\t\($0.getDataAsString())" }.joined(separator: "\n")
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
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
                    
                    
                    let str = self.logs
                    let url = getDocumentsDirectory().appendingPathComponent("\(self.bleManager.listOfMessage.last?.getDataAsString() ?? "error").txt")
                    
                    do {
                        try str.write(to: url, atomically: true, encoding: .utf8)
                        let input = try String(contentsOf: url)
                        print(input)
                    } catch {
                        print(error.localizedDescription)
                    }
                    isAnimating = false
                    withAnimation(Animation.easeOut(duration: 0.5)) {
                        isAnimating = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        isAnimating = false
                    }
                      
                    
                    
                    
                    
                    
                }) {
                    
                    Text("Save")
                        .scaleEffect(1.5)
                        .padding(.horizontal, 20)
                    
                    
                    
                    
                }
                
                
                
                Button(action: {
                    self.isShareSheetPresented.toggle()
                }) {
                    
                    Image(systemName: "square.and.arrow.up")
                        .scaleEffect(1.5)
                        .padding(.horizontal, 20)
                    
                    
                }.sheet(isPresented: $isShareSheetPresented) {
                    ShareSheetView(activityItems: [logs])
                }
                
                
                
                
            }
            
            ZStack{
                ScrollView {
                    Text(logs)
                        .font(.caption)
                        .padding()
                        .foregroundColor(Color(UIColor.darkGray))
                    
                    
                    
                }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .shadow(radius: 3)
                
                Group {
                    Image(systemName: "arrow.down.doc.fill")
                        .font(.system(size: 100))
                        .foregroundColor(Color.green)
                        .shadow(radius: 3)
                }
                .scaleEffect(isAnimating ?  1.0 : 0, anchor: .center)
                
                
                
            }
            
            
            
            
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
