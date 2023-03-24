//
//  CustomTestsPresenter.swift
//  PureMind
//
//  Created by Клим on 11.04.2022.
//

import UIKit
import SwiftCSV

protocol CustomTestsPresenterProtocol{
    init(view: CustomTestsViewProtocol, questionIndex: Int, testIndex: Int)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func getNumberOfItems() -> Int
    func prepareCell(cell: AnswerViewCell, index: IndexPath)
    func calculateScore(index: IndexPath) -> [Double]
    func loadTest()
    var finishIndex: Int! {get}
}

class CustomTestsPresenter: CustomTestsPresenterProtocol{
    
    weak var view: CustomTestsViewProtocol?
    var selectedCells = [IndexPath]()
    var testIndex: Int!
    var answers = [["Полностью согласен", "В основном согласен", "Слегка согласен", "Слегка не согласен", "В основном не согласен", "Полностью не согласен"], ["Совершенно не согласен", "Не согласен", "Не совсем согласен", "В общем-то, согласен", "Согласен", "Полностью согласен"], ["Совсем нехарактерно для меня", "Скорее нехарактерно для меня", "Не знаю", "Скорее характерно для меня", "Очень сильно характерно для меня"], ["Верно", "Трудно сказать", "Неверно"], ["Никогда", "Очень редко", "Редко", "Иногда", "Часто", "Очень часто", "Ежедневно"], ["Полностью согласен", "Согласен", "Более или менее согласен", "Затрудняюсь ответить", "Более или менее не согласен", "Не согласен", "Полностью не согласен"], ["Совсем нет", "Слабо выражено", "Выражено", "Очень выражено"], ["Да", "Нет"], ["Полностью согласен", "Согласен", "Не согласен"]]
    var currAnswers = [String]()
    var coefs = [Double]()
    var finalCoefs = [Double]()
    var headers = [String]()
    var finishIndex: Int!
    var questionIndex: Int!
    
    required init(view: CustomTestsViewProtocol, questionIndex: Int, testIndex: Int) {
        self.view = view
        self.testIndex = testIndex
        self.questionIndex = questionIndex
        self.currAnswers = answers[self.testIndex]
    }
    
    
    
    func loadTest()  {
//        do {
//            let csvFileQuestions: CSV = try CSV(url: Bundle.main.url(forResource: "psy_questions_list_\(testIndex + 1)", withExtension: "csv")!)
//            let ar = csvFileQuestions.enumeratedRows
//            self.finishIndex = ar.count - 1
//            var str = ar[questionIndex][0]
//            for i in 1..<ar[questionIndex].count{
//                str = str + ", " + ar[questionIndex][i]
//            }
//            var startIndex = str.firstIndex(of: ";")
//            startIndex = str.index(after: startIndex!)
//            str = "\(str[startIndex!...])"
//            view?.loadQuestion(questionTitle: str , questionDesc: "")
//            
//            let csvFileList: CSV = try CSV(url: Bundle.main.url(forResource: "psy_questions_table_\(testIndex + 1)", withExtension: "csv")!)
//            startIndex = csvFileList.header[0].firstIndex(of: ";")
//            startIndex = csvFileList.header[0].index(after: startIndex!)
//            str = "\(csvFileList.header[0][startIndex!...])"
//            self.headers = str.components(separatedBy: ";")
//            //var arr = csvFileList.enumeratedRows
//            if questionIndex == csvFileList.enumeratedRows.count - 3{
//                var finalCoef = csvFileList.enumeratedRows[questionIndex + 2][0]
//                startIndex = finalCoef.firstIndex(of: ";")
//                startIndex = finalCoef.index(after: startIndex!)
//                finalCoef = "\(finalCoef[startIndex!...])"
//                self.finalCoefs = finalCoef.components(separatedBy: ";").map{Double($0)!}
//            }
//            var coef = csvFileList.enumeratedRows[questionIndex + 1][0]
//            startIndex = coef.firstIndex(of: ";")
//            startIndex = coef.index(after: startIndex!)
//            coef = "\(coef[startIndex!...])"
//            self.coefs = coef.components(separatedBy: ";").map{Double($0)!}
//        }
//        catch{
//            fatalError("File not found!")
//        }
    }
    
    func calculateScore(index: IndexPath) -> [Double]{
        let score = index.row + 1
        switch finalCoefs{
        case []:
            for i in 0..<coefs.count{
                if coefs[i] != 0{
                    coefs[i] = coefs[i] * Double(score)
                }
            }
        default:
            for i in 0..<coefs.count{
                if coefs[i] != 0{
                    coefs[i] = coefs[i] * Double(score) + finalCoefs[i]
                }
            }
        }
        return coefs
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showCustomResultsSegue":
            guard let vc = segue.destination as? CustomResultsViewController, ((sender as? [Double]) != nil)
            else {fatalError("invalid data passed")}
            vc.presenter = CustomResultsPresenter(view: vc, headers: self.headers, scores: sender as! [Double])
        default:
            break
        }
    }
    
    func getNumberOfItems() -> Int {
        return answers[testIndex].count
    }
    
    func prepareCell(cell: AnswerViewCell, index: IndexPath) {
        cell.textLabel.textColor = newButtonLabelColor
        cell.layer.borderColor = newButtonLabelColor.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 25
            let check = selectedCells.firstIndex(of: index)
            if check == nil{
                cell.backgroundColor = .white
                cell.textLabel.textColor = newButtonLabelColor
            }
            else{
                cell.backgroundColor = newButtonLabelColor
                cell.textLabel.textColor = .white
            }
            cell.textLabel.text = answers[testIndex][index.row]
        
    }
}
