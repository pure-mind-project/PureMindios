//
//  LessonsTablePresenter.swift
//  PureMind
//
//  Created by Клим on 06.02.2022.
//

import UIKit

protocol LessonsTablePresenterProtocol{
    init(view: LessonsTableViewProtocol, data: LessonInfo)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: LessonElementTableViewCell, index: IndexPath)
    func getTitleText(index: Int) -> String
    func countSections() -> Int
    func countRows(section: Int) -> Int
    func getVideoLink(index: Int) -> String
    }

class LessonsTablePresenter: LessonsTablePresenterProtocol{
    weak var view: LessonsTableViewProtocol?
    let networkService = NetworkService.shared
    var data: LessonInfo?
    var titles = ["Видео-лекция", "Рефлексивные вопросы", "Практики", "Доп. литература"]
    

    required init(view: LessonsTableViewProtocol, data: LessonInfo) {
        self.view = view
        self.data = data
    }
    
    func getVideoLink(index: Int) -> String{
        return data!.video ?? ""
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showReflexQuestion":
            guard let vc = segue.destination as? ReflexiveViewController, let info = sender as? LessonsTableInfo
            else {fatalError("invalid data passed")}
            switch info.vcIndex.section {
            case 1:
                vc.titleText = "Рефлексивный вопрос №\(data!.reflexiveQuestions[info.vcIndex.row].name!)"
                vc.descText = (data?.reflexiveQuestions[info.vcIndex.row].text)!
                vc.courseId = info.courseId
                vc.vcIndex = info.vcIndex.row
                vc.lessonIndex = info.lessonIndex
            case 2:
                vc.titleText = (data?.practices[info.vcIndex.row].name)!
                vc.descText = (data?.practices[info.vcIndex.row].text)!
            default:
                vc.titleText = ""
                vc.descText = ""
            }
            
        default:
            break
        }
    }

    func prepareCell(cell: LessonElementTableViewCell, index: IndexPath) {
        cell.elementLabel.textColor = newButtonLabelColor
        switch index.section {
        case 0:
            cell.elementLabel.text = "Видео-лекция"
            cell.elementIcon.image = UIImage(named: "lessonVideo")
        case 1:
            cell.elementLabel.text = "Рефлексивный вопрос \(index.row + 1)"
            cell.elementIcon.image = UIImage(named: "lessonQuestion")
        case 2:
            cell.elementLabel.text = data!.practices[index.row].name
            cell.elementIcon.image = UIImage(named: "lessonPractic")
        case 3:
            cell.elementIcon.image = UIImage(named: "lessonBook")
            cell.elementLabel.text = data!.additionalLiterature![index.row].text
            
        default:
            cell.elementIcon.image = UIImage(named: "noImage")
        }
    
    }

    func getTitleText(index: Int) -> String {
        return titles[index]
    }

    func countRows(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return data!.reflexiveQuestions.count
        case 2:
            return data!.practices.count
        case 3:
            return data!.additionalLiterature?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func countSections() -> Int {
        titles.count
    }

}
