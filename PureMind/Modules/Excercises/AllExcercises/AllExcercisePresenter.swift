//
//  AllExcercisePresenter.swift
//  PureMind
//
//  Created by Клим on 03.01.2022.
//

import UIKit

protocol AllExcercisePresenterProtocol{
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: ExcercisesViewCell, index: Int)
    func getTitleText(index: Int) -> String
    func countData() -> Int
}

class AllExcercisePresenter: AllExcercisePresenterProtocol{
    weak var view: AllExcerciseViewProtocol?
    let networkService:  PracticeServiceManagerProtocol
    var practices = [PracticeRKO]()
    //var practics = ["Страх", "Стыд", "Обида", "Уверенность", "Апатия", "Вина", "Злость", "Стресс"]
    
    required init(view: AllExcerciseViewProtocol, practiceService: PracticeServiceManagerProtocol) {
        self.view = view
        self.networkService = practiceService
        networkService.getPractices { [weak self] (result) in
            switch result {
            case .success(let res):
                print(res.practices)
                for token in res.practices {
                    self?.practices.append(token)
                    self?.view?.updateUI()
                }
                
            case .failure(_):
                self?.view?.failedToLoad()
            }
        }
        
        for practice in practices {
            print((practice.name))
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "practicChosenSegue":
            guard let vc = segue.destination as? PageExcerciseViewController, let info = sender as? [String]
            else {fatalError("invalid data passed")}
            let curPract = practices.first(where: { prac in prac.id.elementsEqual(info[0])})!
            vc.techniqueNumber = Int(info[1])!
            vc.practiceService = networkService
            vc.practiceID = curPract.id
            
        default:
            break
        }
    }

    func prepareCell(cell: ExcercisesViewCell, index: Int) {
//        let group = practics[index]
//        var mas = [PracticesInfo]()
//        for exc in currExcercises {
//            if exc.category == group {
//                mas.append(exc)
//            }
//        }
        cell.practiceID = practices[index].id
        cell.excercises = practices[index].techniques
        cell.parentVC = view
        cell.excercisesTableView.reloadData()
    }
    
    func getTitleText(index: Int) -> String {
        return practices[index].name
    }
    
    func countData() -> Int {
        practices.count
    }

}
