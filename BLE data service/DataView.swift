//
//  MyDeviceView.swift
//  BLE data service
//
//  Created by Tommaso Patriti on 26/04/22.
//

import SwiftUI
import SwiftUICharts

struct DataView: View {
    
    
    @ObservedObject var bleManager = BLEManager.shared()
    
    
    @State private var selectedsender = "None"
    @State private var selectedDataType = "None"
    @State private var dateFilterIsOn = false
    @State private var rangeFilterStart = Date.now
    @State private var rangeFilterStop = Date.now
    @State private var dropDownMenu = false
    @State private var isChartsShowing = false
    
    
    
    var senders : [String] {
        get {
            return ["None"] + getAllSender(messageas: bleManager.listOfMessage)
        }
        
    }
    
    var dataTypes : [String] {
        get {
            return ["None"] + getAllDataType(messageas: bleManager.listOfMessage)
        }
        
    }
    
    var chartData : [LineChartDataPoint]? {
        get {
            return  recivedMessage.filter{
                if Double($0.getValue()) != nil{
                    return true
                    
                }else{
                    return false
                    
                }
                
            }.map{LineChartDataPoint( value: Double($0.getValue()) ?? 0, xAxisLabel: $0.getDataHoureAsString(), description: $0.getDataAsString())}
            
        }
    }
    
    
    
    var chartBarData : [Double]? {
        get {
            return  recivedMessage.filter{
                if Double($0.getValue()) != nil{
                    return true
                    
                }else{
                    return false
                    
                }
                
            }.map{Double($0.getValue()) ?? 0}
            
        }
    }
    
    
    var data : LineChartData {
        get{
            let data = LineDataSet(dataPoints: chartData!,
                                   legendTitle: selectedDataType,
                                   pointStyle: PointStyle(),
                                   style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
            
            let gridStyle  = GridStyle(numberOfLines: 8,
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
                                 chartStyle     : chartStyle)
        }
    }
    
    
    
    
    
    
    
    
    var recivedMessage : [BLEData]! {
        get {
            
            if dateFilterIsOn{
                return bleManager.messagefilterBySenderAndDataType(sender: selectedsender, dataType: selectedDataType)
                    .filter{
                        Int($0.currentDateTime.timeIntervalSince1970) < Int(rangeFilterStop.timeIntervalSince1970)
                        &&
                        Int($0.currentDateTime.timeIntervalSince1970) > Int(rangeFilterStart.timeIntervalSince1970)
                    }
            }
            return bleManager.messagefilterBySenderAndDataType(sender: selectedsender, dataType: selectedDataType)
            
        }
    }
    
    
    
    var chartDate : [Date] {
        get {
            return recivedMessage.map{$0.currentDateTime}
        }
    }
    
    
    
    var body: some View {
        
        
        
        
        VStack (spacing: 0) {
            
            
            
            Text("Data")
                .font(.largeTitle .bold())
                .frame( maxWidth: .infinity, alignment: .topLeading)
                .padding(.top)
                .padding(.horizontal)
            
            
            if bleManager.listOfMessage.count > 0{
                
                HStack{
                    VStack{
                        Text("Sender: \(self.selectedsender)")
                            .frame( maxWidth: .infinity, alignment: .topLeading)
                            .font(.caption)
                            .padding(.horizontal)
                        Text("Data type: \(self.selectedDataType)")
                            .frame( maxWidth: .infinity, alignment: .topLeading)
                            .font(.caption)
                            .padding(.horizontal)
                        Text("Date filter: \(String(self.dateFilterIsOn))")
                            .frame( maxWidth: .infinity, alignment: .topLeading)
                            .font(.caption)
                            .padding(.horizontal)

                    }
                    
                    VStack{
    
                    Button("Edit...", action:{
                        self.dropDownMenu.toggle()

                        
                    })
                    .padding(.horizontal)
                    .buttonStyle(.bordered)
                    .frame(alignment: .topTrailing)
                    
                    
                    if  chartBarData?.count ?? 0 > 0 && self.selectedDataType != "None" && self.selectedsender != "None" {
                        Button("Show charts", action:{
                            self.isChartsShowing.toggle()


                        })
                        .padding(.horizontal)
                        .buttonStyle(.bordered)
                        .frame(alignment: .topTrailing)
                    }else{
                        Text("")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.darkGray))
                            .onAppear{
                                self.isChartsShowing = false
                            }
                    }
                    }.frame(alignment: .topTrailing)
                    
                }.padding(.horizontal)
                

                
                    

    
                
                

                
                ZStack(alignment: .top) {
    
                    VStack{
                        if   self.selectedDataType != "None" && self.selectedsender != "None" && self.isChartsShowing{
                        
                        HorizontalChartView(chartBarData: chartBarData!, lineChartdata: data)
                        .frame(height:300)
                
                                
                    }
                    
                    
                        listOfData(recivedMessage: self.recivedMessage, selectedsender:self.selectedsender, selectedDataType: self.selectedDataType)
                    
                    
                    }
                    
                    
                    
                    if dropDownMenu{
                    VStack{

                        HStack {
                            Text("Sender:")
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Picker("Please choose a sender", selection: $selectedsender) {
                                ForEach(senders, id: \.self) {
                                    Text($0)
                                }
                            }.frame(alignment: .topLeading)
                        }.padding(.horizontal)
                        .padding(.top)
                        
                        Divider()
                        
                        HStack {
                            Text("Data type:")
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Picker("Please choose a Data type", selection: $selectedDataType) {
                                ForEach(dataTypes, id: \.self) {
                                    Text($0)
                                }
                            }.frame(alignment: .topLeading)
                            
                            
                        }.padding(.horizontal)
                        
                        Divider()
                        
                        HStack {
                            VStack{
                                Text("Date range")
                                Toggle("", isOn: $dateFilterIsOn).padding()
                                
                            }
                            
                            VStack{
                                DatePicker("", selection: $rangeFilterStart)
                                DatePicker("", selection:  $rangeFilterStop)
                                    .padding(.bottom)
                            }
                            
                        }.padding(.horizontal)
                        
                        
                        
                        Button(action: {
  
                                self.dropDownMenu.toggle()
   
                        }) {
                            Image(systemName: "chevron.compact.up")
                                .frame(alignment: .center)
                                .font(.system(size: 25.0, weight: .bold))
                                .padding()
                           
                        }

                    }

                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
 
     

                    }
                    
                    

                }.padding()
                
                
                
                
                
                
                
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


struct MyDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataView()
            
            
        }
    }
}
