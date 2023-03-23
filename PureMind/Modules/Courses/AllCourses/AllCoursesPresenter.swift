//
//  AllCoursesPresenter.swift
//  PureMind
//
//  Created by Клим on 16.01.2022.
//

import UIKit

protocol AllCoursesPresenterProtocol {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: SingleCourseViewCell, index: Int)
    func getTitleText(index: Int) -> String
    func getDescriptionText(index: Int) -> String
    func countData() -> Int
}

class AllCoursesPresenter: AllCoursesPresenterProtocol{
    weak var view: AllCoursesViewProtocol?
    let networkService = NetworkService.shared
    var coursesCollection = CoursesRKO(courses: [])
    let networkFactory: NetworkServicesFactoryProtocol
    let coursesServiceManager: CoursesServiceManagerProtocol
    let practicesServicesManager: PracticeServiceManagerProtocol

    required init(view: AllCoursesViewProtocol, networkFactory: NetworkServicesFactoryProtocol) {
        self.view = view
        self.coursesServiceManager = networkFactory.getCourcesService()
        self.practicesServicesManager = networkFactory.getPracticeService()
        self.networkFactory = networkFactory
        coursesServiceManager.getCourses(completion: { res in
            switch res {
            case .success(let courses):
                self.coursesCollection = courses
            case .failure(_):
                self.view?.failedToLoad()
            }
        })
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "practicChosenSegue":
            guard let vc = segue.destination as? PageExcerciseViewController, let string = sender as? [String]
            else {fatalError("invalid data passed")}
            vc.practiceID = string.first!
            
        case "lessonChosenSegue":
            guard let vc = segue.destination as? CourseTabBarViewController, let indexes = sender as? [Int]
            else {fatalError("invalid data passed")}
            let data = coursesCollection.courses[indexes[1]]
            vc.id = data.id
            vc.name = data.name
            vc.courseDescription = data.description
            vc.lessonChosen = indexes[0]
            vc.coursesService = coursesServiceManager
        default:
            break
        }
    }

    func prepareCell(cell: SingleCourseViewCell, index: Int) {
        cell.lessons = coursesCollection.courses[index].lessons
        // ShortLessonInfo
//        networkService.getLessons(courseId: course) {[weak self] (result) in
//            switch result{
//            case let .success(lessons):
//                var sort = lessons
//                sort = sort.sorted{$1.name > $0.name}
//                cell.lessons = sort
//                cell.lessonsTableView.reloadData()
//
//            case .failure(_):
//                self?.view?.failedToLoad()
//            }
//        }
        cell.parentVC = view
        cell.courseIndex = index
        cell.lessonsTableView.reloadData()
    }
    
    func getTitleText(index: Int) -> String {
        return coursesCollection.courses[index].name
    }
    
    func getDescriptionText(index: Int) -> String {
        return coursesCollection.courses[index].description
    }
    
    func countData() -> Int {
        coursesCollection.courses.count
    }

}
