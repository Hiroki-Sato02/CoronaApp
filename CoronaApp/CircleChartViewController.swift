//
//  ChartViewController.swift
//  CoronaApp
//
//  Created by 佐藤大樹 on 2022/03/24.
//

import UIKit
import Charts

class CircleChartViewController: UIViewController {

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
        backButton.frame = CGRect(x: 10, y: 30, width: 100, height: 30)
        backButton.setTitle("棒グラフ", for: .normal)
        backButton.tintColor = colors.white
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
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
        var entries:[PieChartDataEntry] = []
        if pattern == "cases" {
            segment.selectedSegmentIndex = 0
            for i in 0...4 {
                entries += [PieChartDataEntry(value: Double(array[i].cases), label: array[i].name_ja)]
            }
        } else if pattern == "pcr" {
            segment.selectedSegmentIndex = 1
            for i in 0...4 {
                entries += [PieChartDataEntry(value: Double(array[i].pcr), label: array[i].name_ja)]
            }
        } else if pattern == "deaths" {
            segment.selectedSegmentIndex = 2
            for i in 0...4 {
                entries += [PieChartDataEntry(value: Double(array[i].deaths), label: array[i].name_ja)]
            }
        }
        /*let circleView = PieChartView(frame: CGRect(x: view.center.x-200, y: view.center.y-200, width: view.frame.size.width-20, height: view.frame.size.width-20))*/
        let circleView = PieChartView(frame: CGRect(center:  CGPoint(x: view.center.x, y: view.center.y-20), size:  CGSize(width: view.frame.size.width-20, height: view.frame.size.width-20)))
        print("Width \(view.frame.size.width), Height\(view.frame.size.height)")
        print("X \(view.center.x), Y \(view.center.y)")
        circleView.centerText = "Top5"
        circleView.animate(xAxisDuration: 2, easingOption: .easeOutExpo)
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [colors.blue, colors.blueGreen, colors.yellowGreen, colors.yellowOrange, colors.redOrange]
        dataSet.valueTextColor = colors.white
        dataSet.entryLabelColor = colors.white
        circleView.data = PieChartData(dataSet: dataSet)
        circleView.legend.enabled = false
        view.addSubview(circleView)
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

extension CircleChartViewController: ChartViewDelegate {
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

 extension CircleChartViewController: UISearchBarDelegate {
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
extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - size.width / 2.0
        let originY = center.y - size.height / 2.0
        self.init(x: originX, y: originY, width: size.width, height: size.height)
    }
}
