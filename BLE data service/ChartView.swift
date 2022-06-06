//
//  ChartView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 06/06/22.
//

import SwiftUI
import SwiftUICharts
struct ChartView: View {
    
    @ObservedObject var bleManager = BLEManager.shared()
    
    
    @State private var selectedsender = "3432"
    @State private var selectedDataType = "233"

    
    
    var senders : [String] {
        get {
            return getAllSender(messageas: bleManager.listOfMessage)
        }
        
    }
    
    var dataTypes : [String] {
        get {
            return  getAllDataType(messageas: bleManager.listOfMessage)
        }
        
    }
    
    
    
    func getChartData(sender : String, dataType: String) -> [Double]?{

        return  bleManager.messagefilterBySenderAndDataType(sender: sender, dataType: dataType).filter{
            if Double($0.getValue()) != nil{
                return true
            }
            return false
                
        }.map{Double($0.getValue()) ?? 0}
    }
    
    
    func  getLineChartDataPoint(sender : String, dataType: String) -> [LineChartDataPoint]?{
        return  bleManager.messagefilterBySenderAndDataType(sender: sender, dataType: dataType).filter{
            if Double($0.getValue()) != nil{
                return true
            }
                return false
        }.map{LineChartDataPoint( value: Double($0.getValue()) ?? 0, xAxisLabel: $0.getDataHoureAsString(), description: $0.getDataAsString())}

    }
    
    
    
    func getLineChartData(sender : String, dataType: String) -> LineChartData{
        let data = LineDataSet(dataPoints: getLineChartDataPoint(sender: sender, dataType: dataType)!,
                               legendTitle: selectedDataType,
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        let metadata   = ChartMetadata(title: "Line chart", subtitle: "linear distribution of points")
        
        let gridStyle  = GridStyle(numberOfLines: 10,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(90)),
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 10,
                                        
                                        baseline            : .minimumWithMaximum(of: 0),
                                        topLine             : .maximum(of: data.maxValue()),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        return LineChartData(dataSets       : data,
                             metadata       : metadata,
                             chartStyle     : chartStyle)
    }
    
    
    
    
    
    var body: some View {
        
        
        
        VStack (spacing: 0) {
            
            
            
            Text("Charts")
                .font(.largeTitle .bold())
                .frame( maxWidth: .infinity, alignment: .topLeading)
                .padding(.top)
                .padding(.horizontal)
            
            
            if bleManager.listOfMessage.count > 0{
                
                ScrollView{
                    ForEach(self.senders, id: \.self) { sender in
                        ForEach(self.dataTypes, id: \.self) { dataType in
                           
                            HorizontalChartView(chartBarData: getChartData(sender: sender, dataType: dataType)!,
                                                lineChartdata: getLineChartData(sender: sender, dataType: dataType))
                            
                        }
                    }
                    
                }
                
                
                
            }else{
                Text("Device not connected")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .foregroundColor(Color.red)
                    .padding()
                Text("Connect a device or import data").padding()
                
            }
            
        }
        
        .background(Color(UIColor.systemGroupedBackground))
        
        
        
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
