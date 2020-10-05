//
//  ChartViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/3/20.
//

import UIKit
import Charts
import FirebaseDatabase

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: LineChartView!
    
    
    
    var nameOfDevice = String()
    
    var chartValues: [ChartDataEntry] = []
    
    struct firebaseData {
        var date: String
        var temp: Float
        var hum: Float
        var gas: Float
    }
    
    var firebaseContentsArray: [firebaseData] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        uiChart(chart: chartView)
//        uiChart(chart: humChart)
        
        getDataFirebase()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.chartData(type: "Temp")
            self.setData(type: "Temp")
            
//            self.chartData(type: "Gas")
//            self.setData(type: "Gas")
//
//            self.chartData(type: "Hum")
//            self.setData(type: "Hum")
        }
     
    }
    
    func uiChart(chart: LineChartView) {
        chart.rightAxis.enabled = false
        
        
        chart.xAxis.drawAxisLineEnabled = true
        chart.xAxis.drawGridLinesEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1.0
        
        chart.xAxis.labelCount = 12

        
//        chartView.leftAxis.axisMinimum = 0
//        chartView.rightAxis.axisMinimum = 0

        
        let yAxis = chart.leftAxis
        yAxis.axisLineColor = .green
        yAxis.axisLineWidth = 3
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.axisLineWidth = 3
        chart.xAxis.axisLineColor = .green
    }
    
    
    func setData(type: String) {
        if type == "Temp" {
        let set = LineChartDataSet(entries: chartValues, label: "Temp")
        let data = LineChartData(dataSet: set)
            let dateFormatter = DateFormatter()
            chartView.xAxis.valueFormatter = DateValueFormatter()
            
        
        chartView.data = data
        } else if type == "Hum" {
            let set = LineChartDataSet(entries: chartValues, label: "Hum")
            let data = LineChartData(dataSet: set)
                let dateFormatter = DateFormatter()
                chartView.xAxis.valueFormatter = DateValueFormatter()

                
            chartView.data = data
        } else if type == "Gas" {
            let set = LineChartDataSet(entries: chartValues, label: "Gas")
            let data = LineChartData(dataSet: set)
                let dateFormatter = DateFormatter()
                chartView.xAxis.valueFormatter = DateValueFormatter()

                
            chartView.data = data
        } else {}
    }
    

    func getDataFirebase() {
        
        guard let deviceName = UserDefaults.standard.string(forKey: "deviceName") else { return }
        let firebaseReference = Database.database().reference().child("App").child(UserDefaults.standard.string(forKey: "title")!).child("data")
        firebaseReference.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        
                        var firebaseData: ChartViewController.firebaseData = ChartViewController.firebaseData(date: snap.key, temp: placeDict["temp"] as! Float, hum: placeDict["hum"] as! Float, gas: placeDict["gas"] as! Float)
                            
                        self.firebaseContentsArray.append(firebaseData)
                        
//                        print(self.firebaseContentsArray)
                        
                    }
        })
        
        
    }
    
    func chartData(type: String) {
        
        firebaseContentsArray.sort { (lhs: firebaseData, rhs: firebaseData) -> Bool in
//            let date = Date()
//            let formatter = DateFormatter()
//
//            formatter.dateFormat = "dd MMM"
//
//            var dateAsDate = formatter.date(from: lhs.date)
//            var dateAsInt = dateAsDate?.timeIntervalSince1970 ?? 0
//
//            var dataAsData2 = formatter.date(from: rhs.date)
//            var dateAsInt2 = dataAsData2?.timeIntervalSince1970 ?? 0
//
//            return dateAsInt > dateAsInt2
            
            lhs.date > rhs.date
        }
        
        print("in chartData()")
        

        
        if type == "Temp" {
            
            var count = 0
    
            while count<firebaseContentsArray.count {
                
                let dateValue = firebaseContentsArray[count].date
                
                let date = Date()
                let formatter = DateFormatter()
                
                formatter.dateFormat = "dd MMM"
                
                var dateAsDate = formatter.date(from: dateValue)
                var dateAsInt = dateAsDate?.timeIntervalSince1970 ?? 0
                
                chartValues.append(ChartDataEntry(x: dateAsInt, y: Double(firebaseContentsArray[count].temp)
                                                  
            
))
                
                print("chartvalues = \(chartValues)")
                count = count + 1
            }
        }
        
        if type == "Gas" {
            
            var count = 0
    
            while count<firebaseContentsArray.count {
                
                let dateValue = firebaseContentsArray[count].date
                
                let date = Date()
                let formatter = DateFormatter()
                
                formatter.dateFormat = "dd MMM"
                
                var dateAsDate = formatter.date(from: dateValue)
                var dateAsInt = dateAsDate?.timeIntervalSince1970 ?? 0
                
                chartValues.append(ChartDataEntry(x: dateAsInt, y: Double(firebaseContentsArray[count].gas)
))
                
                print("chartvalues = \(chartValues)")
                count = count + 1
            }
        }
        if type == "Hum" {
            
            var count = 0
    
            while count<firebaseContentsArray.count {
                
                let dateValue = firebaseContentsArray[count].date
                
                let date = Date()
                let formatter = DateFormatter()
                
                formatter.dateFormat = "dd MMM"
                
                var dateAsDate = formatter.date(from: dateValue)
                var dateAsInt = dateAsDate?.timeIntervalSince1970 ?? 0
                
                chartValues.append(ChartDataEntry(x: dateAsInt, y: Double(firebaseContentsArray[count].hum)
))
                
                print("chartvalues = \(chartValues)")
                count = count + 1
            }
        }

        
        
    }
    
//    let chartValues: [ChartDataEntry] = [
//        ChartDataEntry(x: 1.0, y: 2.0),
//        ChartDataEntry(x: 2.0, y: 3.0),
//        ChartDataEntry(x: 3.0, y: 4.0),
//        ChartDataEntry(x: 4.0, y: 5.0),
//        ChartDataEntry(x: 5.0, y: 6.0),
//        ChartDataEntry(x: 6.0, y: 10.0)
//    ]
    


}
