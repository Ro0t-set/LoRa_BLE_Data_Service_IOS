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
                

                
                ZStack(alignment: .top) {
                    

                    
                    VStack{
                    if  (chartData?.count)! > 0 && selectedDataType != "None" && selectedsender != "None"{
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                
                                GeometryReader { geometry in
                                    
                                    BarChartView(data: chartBarData!, colors: [Color.purple, Color.blue])
                                        .frame(minWidth: 300, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                                        .background(Color.white.cornerRadius(20))

                                }
                                
                                
                                .frame(width: 300, height: 300)
                                Divider()
                                GeometryReader { geometry in
                                    
                                    VStack{
                                        LineChart(chartData: data)
                                            .pointMarkers(chartData: data)
                                            .touchOverlay(chartData: data, specifier: "%s")
                                            .floatingInfoBox(chartData: data)
                                            .xAxisGrid(chartData: data)
                                            .yAxisGrid(chartData: data)
                                            .xAxisLabels(chartData: data)
                                            .yAxisLabels(chartData: data)
                                            .infoBox(chartData: data)
                                            .headerBox(chartData: data)
                                            .legends(chartData: data)
                                            .id(data.id)
                                            .frame(minWidth: 300, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                                            .padding()
                                        
                                        
                                    }.background(Color.white.cornerRadius(20))
                                    
                                    
                                }
                                .frame(width: 300, height: 300)
                                
                                
                                Spacer()
                                Divider()
                            }
                        }
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
                            .padding(.top, 50)
                        
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

                    }

                    .background(.regularMaterial,
                                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    )
                    .cornerRadius(20)
                    
 
     

                    }
                    
                    
                    Button(action: {
                        
                        withAnimation(Animation.spring()) {
                            self.dropDownMenu.toggle()
                            
                        }
                        
                    }) {
                        Image(systemName: "magnifyingglass.circle")
                            .frame(alignment: .center)
                            .font(.system(size: 45.0, weight: .bold))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .cornerRadius(50)
                            .offset(y: 40)
                            .padding(.bottom, -40)
                            

                            
                            
                            
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
