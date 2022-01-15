//
//  MoodPresenter.swift
//  PureMind
//
//  Created by Клим on 17.08.2021.
//

import UIKit
import Charts

protocol MoodPresenterProtocol{
    init(view: MoodViewProtocol, currMood: String)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: PracticViewCell, index: Int)
    func practicsCount() -> Int
    func setDataCount(_ count: Int, range: UInt32) -> ChartData
    var currMood: String? {get}
}

class MoodPresenter: MoodPresenterProtocol{
    weak var view: MoodViewProtocol?
    var currMood: String?
    var practics = ["Страх", "Стыд", "Обида", "Уверенность", "Апатия", "Вина", "Злость", "Стресс", "Все темы"]
    
    required init(view: MoodViewProtocol, currMood: String) {
        self.view = view
        self.currMood = currMood
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "chatMoodSegue":
            guard let vc = segue.destination as? ChatViewController
            else {fatalError("invalid data passed")}
            vc.presenter = ChatPresenter(view: vc)
            
        default:
            break
        }
    }
    
    func practicsCount() -> Int {
        return 5
    }
    
    func prepareCell(cell: PracticViewCell, index: Int) {
        var color = UIColor(red: 254, green: 227, blue: 180)
        if (index + 1) % 3 == 0 {
            color = UIColor(red: 255, green: 228, blue: 197)
        }
        else if (index + 1) % 4 == 0 {
            color = UIColor(red: 253, green: 214, blue: 201)
        }
        else if (index + 1) % 2 == 0 && (index + 1) % 3 != 0{
            color = UIColor(red: 251, green: 210, blue: 174)
        }
        cell.practicLabel.text = practics[index]
        cell.backgroundColor = color
        cell.excerciseCount.text = "\(index + 1) техник"
        cell.layer.cornerRadius = 14
    }
    
    func setDataCount(_ count: Int, range: UInt32) -> ChartData {
            let now = Date().timeIntervalSince1970
            let hourSeconds: TimeInterval = 3600
            
            let from = now - (Double(count) / 2) * hourSeconds
            let to = now + (Double(count) / 2) * hourSeconds
            
            let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
                let y = arc4random_uniform(range) + 50
                return ChartDataEntry(x: x, y: Double(y))
            }
            
            let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
            set1.axisDependency = .left
            set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = false
            set1.fillAlpha = 0.26
            set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSet: set1)
            data.setValueTextColor(.white)
            data.setValueFont(.systemFont(ofSize: 9, weight: .light))
            
            return data
        }
}
