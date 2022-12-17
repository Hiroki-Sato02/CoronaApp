//
//  ChartViewController.swift
//  CoronaApp
//
//  Created by 佐藤大樹 on 2022/03/24.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    let colors = Colors()
    var prefecture = UILabel()
    var pcr = UILabel()
    var pcrCount = UILabel()
    var cases = UILabel()
    var casesCount = UILabel()
    var deaths = UILabel()
    var deathsCount = UILabel()
    var segment = UISegmentedControl()
    var array:[CovidInfo.Prefecture] = []
    var chartView:HorizontalBarChartView!
    var pattern = "cases"
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [colors.bluePurple.cgColor, colors.blue.cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setImage(UIImage(named:  "back"), for: .normal)
        backButton.tintColor = colors.white
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: view.frame.size.width-105, y: 25, width: 100, height: 30)
        nextButton.setTitle("円グラフ", for: .normal)
        nextButton.setTitleColor(colors.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        view.addSubview(nextButton)
        
        segment = UISegmentedControl(items: ["感染者数", "PCR数", "死者数"])
        segment.frame = CGRect(x: 10, y: 70, width: view.frame.size.width-20, height: 20)
        segment.selectedSegmentTintColor = colors.blue
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        segment.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        view.addSubview(segment)
        
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width-20, height: 20)
        searchBar.delegate = self
        searchBar.placeholder = "都道府県を漢字で入力"
        searchBar.showsCancelButton = true
        searchBar.tintColor = colors.blue
        view.addSubview(searchBar)
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 10, y: view.frame.size.height-200, width: view.frame.size.width-20, height: 167)
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 10
        uiView.layer.shadowColor = colors.black.cgColor
        uiView.layer.shadowOpacity = 0.4
        uiView.layer.shadowRadius = 10
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(uiView)
        
        bottonLabel(uiView, prefecture, 1, 10, text: "東京", size: 30, weight: .ultraLight, color: colors.black)
        bottonLabel(uiView, pcr,0.39, 50, text: "PCR数", size: 15, weight: .bold, color: colors.bluePurple)
        bottonLabel(uiView, pcrCount,0.39, 85, text: "2222222", size: 30, weight: .bold, color: colors.blue)
        bottonLabel(uiView, cases,1, 50, text: "感染者数", size: 15, weight: .bold, color: colors.bluePurple)
        bottonLabel(uiView, casesCount,1, 85, text: "22222", size: 30, weight: .bold, color: colors.blue)
        bottonLabel(uiView, deaths,1.61, 50, text: "死者数", size: 15, weight: .bold, color: colors.bluePurple)
        bottonLabel(uiView, deathsCount,1.61, 85, text: "2222", size: 30, weight: .bold, color: colors.blue)
        
        view.backgroundColor = .systemGroupedBackground
        
        
        for i in 0..<CovidSingleton.shared.prefecuture.count {
            if CovidSingleton.shared.prefecuture[i].name_ja == "東京" {
                prefecture.text = CovidSingleton.shared.prefecuture[i].name_ja
                pcrCount.text = "\(CovidSingleton.shared.prefecuture[i].pcr)"
                casesCount.text = "\(CovidSingleton.shared.prefecuture[i].cases)"
                deathsCount.text = "\(CovidSingleton.shared.prefecuture[i].deaths)"
            }
        }
        
        chartView = HorizontalBarChartView(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: view.frame.size.height-353))
        chartView.animate(yAxisDuration: 1.0, easingOption: .easeOutCirc)
        chartView.xAxis.labelCount = 10
        chartView.xAxis.labelTextColor = colors.bluePurple
        chartView.doubleTapToZoomEnabled = false
        chartView.delegate = self
        chartView.pinchZoomEnabled = false
        chartView.leftAxis.labelTextColor = colors.bluePurple
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        
        array = CovidSingleton.shared.prefecuture
        array.sort(by: {
            a, b -> Bool in
            if pattern == "pcr" {
                return a.pcr > b.pcr
            } else if pattern == "deaths" {
                return a.deaths > b.deaths
            } else {
            return a.cases > b.cases
            }
        })
        dataSet()
        
    }
    func dataSet() {
        var names:[String] = []
        for i in 0...9 {
            names += ["\(self.array[i].name_ja)"]
        }
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: names)
        
        var entries:[BarChartDataEntry] = []
        for i in 0...9 {
            if pattern == "cases" {
                segment.selectedSegmentIndex = 0
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.array[i].cases))]
            } else if pattern == "pcr" {
                segment.selectedSegmentIndex = 1
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.array[i].pcr))]
            } else if pattern == "deaths" {
                segment.selectedSegmentIndex = 2
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.array[i].deaths))]
            }
        }
        let set = BarChartDataSet(entries: entries, label: "県別状況")
        set.colors = [colors.blue]
        set.valueTextColor = colors.white
        set.highlightColor = colors.white
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
        
    }
    @objc func switchAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pattern = "cases"
        case 1:
            pattern = "pcr"
        case 2:
            pattern = "deaths"
        default:
            break
        }
        loadView()
        viewDidLoad()
    }
    @objc func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    @objc func goCircle() {
        performSegue(withIdentifier: "goCircle", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func bottonLabel(_ parentView: UIView, _ label: UILabel, _ x: CGFloat, _ y: CGFloat, text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: size, weight: weight)
        label.frame = CGRect(x: 0, y: y, width: parentView.frame.size.width/3.5, height: 50)
        label.center.x = view.center.x * x-10
        parentView.addSubview(label)
    }

}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
            let index = dataSet.entryIndex(entry: entry)
            prefecture.text = "\(array[index].name_ja)"
            pcrCount.text = "\(array[index].pcr)"
            casesCount.text = "\(array[index].cases)"
            deathsCount.text = "\(array[index].deaths)"
        }
    }
}

extension ChartViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let index = array.firstIndex(where: { $0.name_ja == searchBar.text}) {
            prefecture.text = "\(array[index].name_ja)"
            pcrCount.text = "\(array[index].pcr)"
            casesCount.text = "\(array[index].cases)"
            deathsCount.text = "\(array[index].deaths)"
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
    }
}
