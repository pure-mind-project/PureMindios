//
//  FirstQuestionsPresenter.swift
//  PureMind
//
//  Created by Клим on 16.08.2021.
//

import UIKit

protocol FirstQuestionsPresenterProtocol{
    init(view: FirstQuestionsViewProtocol, currMood: String, networkService: MoodTrackerServiceManagerProtocol)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func getNumberOfSections() -> Int
    func getNumberOfItems(section: Int) -> Int
    func getSelectedAnswersCount() -> Int
    func prepareCell(cell: AnswerViewCell, index: IndexPath)
    func manageAnswer(index: IndexPath)
    func manageCustomAnswer(answer: String, index: IndexPath)
    func prepareView()
    func calculateScore(index: IndexPath) -> Int
    func cacheCurrMood(moodScore: Int)
    var currMood: String? {get}
}

class FirstQuestionsPresenter: FirstQuestionsPresenterProtocol{
    weak var view: FirstQuestionsViewProtocol?
    var networkService: MoodTrackerServiceManagerProtocol
    var currMood: String?
    var currMoodColor: UIColor?
    var selectedCells = [IndexPath]()
    var selectedAnswers = [String]()
    var phonyData = [["Гордость", "Спокойствие", "Уверенность", "Радость", "Счастье", "Возбуждение", "Благодарность", "Мотивация", "Вдохновение", "Облегчение", "Безопасность", "Печаль", "Злость", "Скука", "Стыд", "Разочарование", "Одиночество", "Вина", "Усталость", "Тревога"]]
    
    required init(view: FirstQuestionsViewProtocol, currMood: String, networkService: MoodTrackerServiceManagerProtocol) {
        self.view = view
        self.currMood = currMood
        self.networkService = networkService
    }
    
    func calculateScore(index: IndexPath) -> Int{
        let mood = phonyData[index.section][index.row]
        switch mood {
        case "Злость", "Разочарование", "Одиночество", "Тревога" :
            return 1
        case "Печаль", "Усталость", "Скука", "Стыд", "Вина" :
            return 2
        case "Облегчение", "Спокойствие", "Безопасность" :
            return 3
        case "Радость", "Гордость", "Балгодарность", "Уверенность" :
            return 4
        case "Вдохновение", "Мотивация", "Счастье" :
            return 5
        
        default:
            return 0
        }
    }
    
    func cacheCurrMood(moodScore: Int) {
        let score = Double(moodScore / 3)
        let info = MoodInfo(score: Double(score), date: Int(Date().timeIntervalSince1970))
        CachingService.shared.cacheMoodData(info, currDate: Date())
    }
    
    func prepareView(){
        view?.loadQuestion(mood: currMood!, questionTitle: "", questionDesc: "")
        view?.loadMood(mood: currMood!)
        switch currMood {
        case "Отлично":
            view?.setBackgroundColor(color: perfectMood)
            currMoodColor = perfectMood
        case "Хорошо":
            view?.setBackgroundColor(color: goodMood)
            currMoodColor = goodMood
        case "Нормально":
            view?.setBackgroundColor(color: normalMood)
            currMoodColor = normalMood
        case "Плохо":
            view?.setBackgroundColor(color: badMood)
            currMoodColor = badMood
        case "Ужасно":
            view?.setBackgroundColor(color: awfulMood)
            currMoodColor = awfulMood
        default:
            view?.setBackgroundColor(color: .white)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "moodSecondSegue":
            guard let vc = segue.destination as? SecondQuestionsViewController
            else {fatalError("invalid data passed")}
            vc.presenter = SecondQuestionsPresenter(view: vc, currMood: sender as! String)
            
        default:
            break
        }
    }
    
    func getNumberOfItems(section: Int) -> Int {
        return phonyData[section].count + 1
    }
    
    func getNumberOfSections() -> Int {
        return phonyData.count
    }
    
    func getSelectedAnswersCount() -> Int {
        return selectedAnswers.count
    }
    
    func manageCustomAnswer(answer: String, index: IndexPath){
        phonyData[index.section].append(answer)
        selectedAnswers.append(answer)
        selectedCells.append(index)
        
        view?.updateUI()
    }
    
    func manageAnswer(index: IndexPath) {
        let check = selectedAnswers.firstIndex(of: phonyData[index.section][index.row])
        if check == nil{
            selectedAnswers.append(phonyData[index.section][index.row])
            selectedCells.append(index)
        }
        else{
            selectedAnswers.remove(at: check!)
            let indexCell = selectedCells.firstIndex(of: index)
            selectedCells.remove(at: indexCell!)
        }
        view?.updateUI()
    }
    
    func prepareCell(cell: AnswerViewCell, index: IndexPath) {
        cell.textLabel.textColor = newButtonLabelColor
        cell.layer.borderColor = newButtonLabelColor.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        if index.row > phonyData[index.section].count - 1{
            cell.textLabel.text = "+"
        }
        else{
            let check = selectedCells.firstIndex(of: index)
            if check == nil{
                cell.backgroundColor = .white
            }
            else{
                cell.backgroundColor = currMoodColor
            }
            cell.textLabel.text = phonyData[index.section][index.row]
        }
    }
}
