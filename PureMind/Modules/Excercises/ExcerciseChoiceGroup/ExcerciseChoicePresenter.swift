//
//  ExcerciseChoicePresenter.swift
//  PureMind
//
//  Created by Клим on 07.10.2021.
//

import UIKit

protocol ExcerciseChoicePresenterProtocol{
    init(view: ExcerciseChoiceViewProtocol, currPractic: String)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: SingleExcerciseViewCell, index: Int)
    func practicsCount() -> Int
    func getExcerciseCode(index: Int) -> [String]
    func loadView()
    
}

class ExcerciseChoicePresenter: ExcerciseChoicePresenterProtocol{
    
    let networkService = NetworkService.shared
    
    weak var view: ExcerciseChoiceViewProtocol?
    var currPractic: String?
    var currExcercises = [String]()
    var currExcercisesId = [String]()
    
    required init(view: ExcerciseChoiceViewProtocol, currPractic: String) {
        self.view = view
        self.currPractic = currPractic
        networkService.getPractices { [weak self] (result) in
            switch result{
            case let .success(tokens):
                for token in tokens {
                    if token.category == currPractic{
                        self?.currExcercises.append(token.name)
                        self?.currExcercisesId.append(token.id)
                        self?.loadView()
                    }
                }
                
            case .failure(_):
                self?.view?.failedToLoad()
            }
        }
    }
    
    func loadView(){
        self.view?.updateUI(practic: self.currPractic!)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "pageExcerciseSegue":
            guard let vc = segue.destination as? PageExcerciseViewController, let string = sender as? [String]
            else {fatalError("invalid data passed")}
            vc.practiceID = string.first!
            
        default:
            break
        }
    }
    
    func getExcerciseCode(index: Int) -> [String] {
        return [currExcercisesId[index], currPractic!, currExcercises[index]]
    }
    
    func practicsCount() -> Int {
        return currExcercises.count
    }
    
    func prepareCell(cell:  SingleExcerciseViewCell, index: Int) {
        cell.titleLabel.text = currExcercises[index]
        cell.titleLabel.textColor = newButtonLabelColor
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = newButtonLabelColor.cgColor
        
    }
    
}
