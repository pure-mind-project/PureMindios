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
    func loadPracticData()
    func getData()
    var currMood: String? {get}
    var moodChartData: ChartData! {get}
}

class MoodPresenter: MoodPresenterProtocol{
    var moodChartData: ChartData!
    weak var view: MoodViewProtocol?
    var currMood: String?
    var practics = [String]()
    var excerciseCounts = [Int]()
    
    required init(view: MoodViewProtocol, currMood: String) {
        self.view = view
        self.currMood = currMood
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "moodExcSegue":
            guard let vc = segue.destination as? ExcerciseChoiceViewController, let index = sender as? Int
            else {fatalError("invalid data passed")}
            let string = practics[index]
            vc.presenter = ExcerciseChoicePresenter(view: vc, currPractic: string)
            
        case "moodAllExcSegue":
            guard let vc = segue.destination as? AllExcercisesViewController
            else {fatalError("invalid data passed")}
            // vc.presenter = AllExcercisePresenter(view: vc)
            
        default:
            break
        }
    }
    
    func loadPracticData(){
        NetworkService.shared.getPractices {[weak self] (result) in
            switch result{
            case let .success(tokens):
                var p = [String]()
                var ec = [Int]()
                for i in 0..<tokens.count {
                    if !p.contains(tokens[i].category){
                        p.append(tokens[i].category)
                        ec.append(1)
                    }
                    else{
                        let ind = p.lastIndex(of: tokens[i].category)
                        ec[ind!] = ec[ind!] + 1
                    }
                }
                self?.practics = p
                self?.excerciseCounts = ec
                self?.practics.append("Все темы")
                self?.view?.updateUI()
            case .failure(_):
                fatalError("Data didnt load")
            }
        }
    }
    
    func practicsCount() -> Int {
        return practics.count
    }
    
    func conv(n: Int) -> String{
        let mas = ["а", "и", ""]
        let n = n % 100
        var str = ""
        if n >= 11 && n <= 19{
            str = mas[2]
        }
        else{
            let i = n % 10
            if i == 1{
                str = mas[0]
            }
            else if [2,3,4].contains(i){
                str = mas[1]
            }
            else{
                str = mas[2]
            }
        }
        return str
    }
    
    func prepareCell(cell: PracticViewCell, index: Int) {
        /*
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
         */
        cell.backgroundColor = .clear
        cell.practicLabel.text = practics[index]
        //cell.backgroundColor = color
        if index == practicsCount() - 1{
            cell.excerciseCount.text = ""
        }
        else{
            cell.excerciseCount.text = "\(excerciseCounts[index]) техник\(conv(n: excerciseCounts[index]))"
        }
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = newButtonLabelColor.cgColor
        cell.layer.borderWidth = 1
        cell.practicLabel.textColor = newButtonLabelColor
        cell.excerciseCount.textColor = newButtonLabelColor
    }
    
    func getData() {
        CachingService.shared.getAllMoodData {[weak self] (result) in
            var raw = [ChartDataEntry]()
            for data in result{
                let date = Double(data.date) + 0.970471
                raw.append(ChartDataEntry(x: date, y: Double(data.score)))
            }
            //raw.append(ChartDataEntry(x: 1644133135.970471, y: 5.0))
            //raw.append(ChartDataEntry(x: 1644135135.970471, y: 3.0))
            let set1 = LineChartDataSet(entries: raw, label: "DataSet 1")
            set1.axisDependency = .left
            set1.setColor(UIColor(red: 144, green: 191, blue: 255))
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = true
            set1.circleRadius = 3
            set1.circleColors = [UIColor(red: 144, green: 191, blue: 255)]
            set1.drawValuesEnabled = false
            set1.fillAlpha = 0.26
            set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSet: set1)
            data.setValueTextColor(.white)
            data.setValueFont(.systemFont(ofSize: 9, weight: .light))
            self?.moodChartData = data
            
            self?.view?.updateChart()
        }
    }
}

