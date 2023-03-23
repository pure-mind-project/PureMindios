//
//  SecondaryTabBarViewController.swift
//  PureMind
//
//  Created by Клим on 06.02.2022.
//

import UIKit
import Parchment

struct SecondaryTabBarViewControllerInitInfo {
    var id: String
    var courseService: CoursesServiceManagerProtocol
    var lessonChosen: Int
    var courseInfo: CourseFullInfoRKO?
}

class SecondaryTabBarViewController: UIViewController {
    var id: String?
    var courseService: CoursesServiceManagerProtocol?
    var lessonChosen = 0
    var courseInfo: CourseFullInfoRKO?
    
    private var pagingViewController: PagingViewController!
    let mod = ModuleBuilder()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(courseID: String, courseService: CoursesServiceManagerProtocol) {
        id = courseID
        self.courseService = courseService
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var viewControllers = [UIViewController]()
        
        if let id = id, let courseService = courseService {
            courseService.getCourseInfo(courseID: id, completion: { res in
                switch res {
                case .success(let courseInfo):
                    self.courseInfo = courseInfo
                    for i in 0..<courseInfo.lessons.count{
                        var reflexCount = 0
                        if i != 0 {
                            reflexCount = self.courseInfo?.lessons[i - 1].questions.count ?? 0
                        }
                        viewControllers.append((self.mod.createLessonModule(data: (self.courseInfo?.lessons[i])!, index: i, previousReflexCount: reflexCount, courseId: (self.id)!)))
                    }
                    self.pagingViewController = PagingViewController(viewControllers: viewControllers)
                    self.setupParchment()
                    self.setFirstVC()
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //CachingService.shared.cacheCourseInfo(self.courseInfo, id: id)
    }
    
    func setFirstVC(){
        pagingViewController.select(index: lessonChosen, animated: true)
        
    }
    
    func alert(){
        let alert = UIAlertController(title: "Ошибка", message: "Проверьте ваше соединение с интернетом", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func setupParchment(){
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        //pagingViewController.menuInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: -10, right: 0)
        //pagingViewController.menuItemSize = .sizeToFit(minWidth: 50, height: 95)
        pagingViewController.font = UIFont(name: "Jost-Medium", size: 13)!
        pagingViewController.selectedFont = UIFont(name: "Jost-Medium", size: 13)!
        pagingViewController.textColor = newButtonLabelColor
        pagingViewController.indicatorColor = newButtonLabelColor
        pagingViewController.selectedBackgroundColor = newButtonLabelColor
        pagingViewController.selectedTextColor = .white
        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
    }

}
