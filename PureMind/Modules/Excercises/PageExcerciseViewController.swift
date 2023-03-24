//
//  PageExcerciseViewController.swift
//  PureMind
//
//  Created by Клим on 12.10.2021.
//

import UIKit

class PageExcerciseViewController: UIPageViewController {
    
    var practiceID = ""
    var techniqueNumber = 0
    // var technique: PracticeInfoRKO!
    // var practiceName = ""
    var excerciseControllers = [UIViewController]()
    var mod = ModuleBuilder()
    var practiceService: PracticeServiceManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        dataSource = self
        setViewControllers()
    }
    
    func start(){
        if let firstViewController = excerciseControllers.first {
                       setViewControllers([firstViewController],
                        direction: .forward,
                           animated: true,
                           completion: nil)
            
        }
    }
    
    func alert(){
        let alert = UIAlertController(title: "Ошибка", message: "Проверьте ваше соединение с интернетом", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func setViewControllers() {
        practiceService.getPracticeInfo(practiceId: practiceID, completion: { res in
            switch res {
            case .success(let practiceInfo):
                let curTech = practiceInfo.techniques[self.techniqueNumber]
                self.excerciseControllers = self.mod.createPractice(info: curTech, title: practiceInfo.name, practiceName: curTech.name)
                self.start()
            case .failure(_):
                break
            }
        })
        
        
//        networkService.getAllExcerciseData(practicId: info[0]){ [weak self] (result) in
//            switch result{
//            case let .success(tokens):
//                self?.excerciseControllers = (self?.mod.createAnyPractic(info: tokens, title: (self?.info[1])!, practicName: (self?.info[2])!))!
//                self?.start()
//
//            case let .failure(error):
//                print(error)
//                self?.alert()
//                self?.navigationController?.popViewController(animated: true)
//            }
//        }
    }
}

extension PageExcerciseViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = excerciseControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard excerciseControllers.count > previousIndex else {
            return nil
        }
        return excerciseControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = excerciseControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = excerciseControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return excerciseControllers[nextIndex]
    }
}
