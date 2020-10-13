//
//  SimpleChartViewController.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import UIKit
import Charts

class SimpleChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    var dataSets: [LineChartDataSet]!
    var chartTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = chartTitle
        chartView.backgroundColor = .white
        chartView.delegate = self
        chartView.xAxis.valueFormatter = DateValueFormatter()
        view.addSubview(chartView)
        setData()
        // Do any additional setup after loading the view.
    }
    
    private func setData() {
        let data = LineChartData(dataSets: dataSets)
        chartView.data = data
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

