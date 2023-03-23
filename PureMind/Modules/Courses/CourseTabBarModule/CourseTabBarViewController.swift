//
//  CourseTabBarViewController.swift
//  PureMind
//
//  Created by Клим on 06.02.2022.
//

import UIKit
import Parchment

class CourseTabBarViewController: UIViewController {
    
    var id: String!
    var name: String!
    var courseDescription: String!
    var coursesService: CoursesServiceManagerProtocol!
    var lessonChosen = 0
    
    private var pagingViewController: PagingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondaryTabVC") as SecondaryTabBarViewController
        firstViewController.id = id
        firstViewController.lessonChosen = lessonChosen
        firstViewController.courseService = coursesService
        
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CourseInfoVC") as CourseInfoViewController
        secondViewController.titleText = name
        secondViewController.courseDescriptionText = courseDescription ?? "Описание к курсу отсутсвтует"
        pagingViewController = PagingViewController(viewControllers: [
              firstViewController,
              secondViewController
            ])
        
        setUpPagingViewController()
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpPagingViewController() {
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.menuInsets = UIEdgeInsets.init(top: 90, left: 0, bottom: -10, right: 0)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 50, height: 55)
        pagingViewController.font = UIFont(name: "Jost-Medium", size: 15)!
        pagingViewController.selectedFont = UIFont(name: "Jost-Medium", size: 15)!
        pagingViewController.textColor = newButtonLabelColor
        pagingViewController.indicatorColor = newButtonLabelColor
        pagingViewController.menuBackgroundColor = UIColor(patternImage: UIImage(named: "background15")!)
        pagingViewController.selectedBackgroundColor = .clear
        pagingViewController.selectedTextColor = .white
        
        let backButton = UIButton(frame: CGRect(x: 20, y: 50, width: 25, height: 25))
        backButton.setTitle("", for: .normal)
        backButton.setBackgroundImage(UIImage(named: "newBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        pagingViewController.view.addSubview(backButton)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 80, y: 39, width: 320, height: 45)
        label.numberOfLines = 0
        label.text = name
        label.font = UIFont(name: "Jost-Medium", size: 20)
        label.textColor = newButtonLabelColor
        pagingViewController.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -15),
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
    }
}
