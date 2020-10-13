//
//  StatsTableViewController.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import UIKit
import Charts

class StatsTableViewController: UITableViewController, StatsCellDelegate {
    var simpleLineCharts = [("Overall Feeling", Data.OverallFeeling), ("Sleep Quality", Data.SleepQuality), ("Sleep Duration", Data.SleepDuration), ("Anxiety Level", Data.AnxietyLevel), ("Work Intencity", Data.WorkIntensity), ("Training Intencity", Data.WorkIntensity), ("Stress Level", .StressLevel)]
    var sectionNames = ["Simple Line Charts"]
    var sections: [[(String, Data)]] = [[(String, Data)]]()
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.refreshControl = refresher
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        InputDataSource.shared.fetchInput {
            self.tableView.isHidden = false
            self.createSections()
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        InputDataSource.shared.fetchInput {
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
        
       // Configure the cell’s contents.
        cell.title.text = sections[indexPath.section][indexPath.row].0
        cell.dataType = sections[indexPath.section][indexPath.row].1
        cell.delegate = self
           
       return cell
    }
    
    func cellPressed(dataType: Data, label: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SimpleChartViewController = storyboard.instantiateViewController(withIdentifier: "simpleChartVC") as! SimpleChartViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.dataSets = createDataSet(type: dataType, label: label)
        vc.chartTitle = label
        self.present(vc, animated: true, completion: nil)
    }
    
    func createDataSet(type: Data, label: String) -> [LineChartDataSet] {
        var datasets = [LineChartDataSet]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        switch type {
        case .OverallFeeling:
            var morningEntries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getMorningInputs().enumerated() {
                morningEntries.append(ChartDataEntry(x: Double(index), y: Double(item.overallFeeling)))
                let date = item.date.iso8601withFractionalSeconds
                print(formatter.string(from: date!))
            }
            var eveningEntries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getEveningInputs().enumerated() {
                eveningEntries.append(ChartDataEntry(x: Double(index), y: Double(item.overallFeeling)))
            }
            datasets.append(LineChartDataSet(entries: morningEntries, label: "Morning+ " + label))
            datasets.append(LineChartDataSet(entries: eveningEntries, label: "Evening " + label))
        case .StressLevel:
            var morningEntries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getMorningInputs().enumerated() {
                morningEntries.append(ChartDataEntry(x: Double(index), y: Double(item.stressLevel)))
            }
            var eveningEntries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getEveningInputs().enumerated() {
                eveningEntries.append(ChartDataEntry(x: Double(index), y: Double(item.stressLevel)))
            }
            datasets.append(LineChartDataSet(entries: morningEntries, label: "Morning " +  label))
            datasets.append(LineChartDataSet(entries: eveningEntries, label: "Evening " + label))
        case .SleepDuration:
            var entries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getMorningInputs().enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item.sleepDuration)))
            }
            datasets.append(LineChartDataSet(entries: entries, label: label))
        case .SleepQuality:
            var entries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getMorningInputs().enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item.sleepQuality)))
            }
            datasets.append(LineChartDataSet(entries: entries, label: label))
        case .WorkIntensity:
            var entries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getEveningInputs().enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item.workIntensity)))
            }
            datasets.append(LineChartDataSet(entries: entries, label: label))
        case .TrainingIntensity:
            var entries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getEveningInputs().enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item.trainingIntensity)))
            }
            datasets.append(LineChartDataSet(entries: entries, label: label))
        case .AnxietyLevel:
            var entries = [ChartDataEntry]()
            for (index, item) in InputDataSource.shared.getEveningInputs().enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item.anxietyLevel)))
            }
            datasets.append(LineChartDataSet(entries: entries, label: label))
        }
        
        return datasets
    }
    
    private func createSections() {
        sections = [simpleLineCharts]
    }

}

