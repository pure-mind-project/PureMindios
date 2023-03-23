//
//  ModuleBuilder.swift
//  PureMind
//
//  Created by Клим on 06.07.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createWelcomeModule() -> UIViewController
    func createMenuModule() -> UIViewController
    func createProfileModule() -> UIViewController
    func createMoodModuleOne(mood: String, vcIndex: Int) -> UIViewController
    func createMoodModuleTwo(mood: String, vcIndex: Int) -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol {
    
    private static let resolver = Resolver()
    public static let shared = ModuleBuilder()
    
    public static func registerInResolver<T>(type: T.Type = T.self, _ factory: () -> T) {
        resolver.register(type: type, factory)
    }
    
    func createWelcomeModule() -> UIViewController {
        let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WelcomeVC") as WelcomeViewController
        let navC = UINavigationController(rootViewController: welcomeVC)
        return navC
    }
    
    func createLessonModule(data: LessonRKO, index: Int, previousReflexCount: Int, courseId: String) -> UIViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LessonsVC") as LessonsTableViewController
        let initInfo = LessonsTableViewControllerInitInfo(presenter: LessonsTablePresenter(view: vc, data: data), courseId: courseId, vcIndex: index, previousReflexCount: previousReflexCount)
        vc.initInfo = initInfo
        vc.title = "Урок №\(index + 1)"
        let navC = UINavigationController(rootViewController: vc)
        return navC
    }
    
    func createWelcomeModuleReturnee() -> UIViewController {
        let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WelcomeVC") as WelcomeViewController
        return welcomeVC
    }
    
    func createMenuModule() -> UIViewController {
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuVC") as MenuViewController
        let networkManager = ModuleBuilder.resolver.resolve(type: NetworkServicesFactoryProtocol.self) as! NetworkServicesFactoryProtocol
        menuVC.presenter = MenuPresenter(view: menuVC, networkService: networkManager)
        let navC = UINavigationController(rootViewController: menuVC)
        return navC
    }
    
    func createDiarymodule() -> UIViewController {
        let diaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DiaryVC") as DiaryStagesViewController
        diaryVC.presenter = DiaryStagesPresenter(view: diaryVC)
        let navVC = UINavigationController(rootViewController: diaryVC)
        return navVC
    }
    
    func createTabModule() ->UIViewController{
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBar") as MainTabBarController
        return menuVC
    }
    
    func createTherapistModule() -> UIViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TherapistVC") as TherapistSubViewController
        vc.backButtonHidden = true
        return vc
    }
    
    func createPracticModule() -> UIViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllExcVC") as AllExcercisesViewController
        let networkManager = ModuleBuilder.resolver.resolve(type: NetworkServicesFactoryProtocol.self) as! NetworkServicesFactoryProtocol
        vc.presenter = AllExcercisePresenter(view: vc, practiceService: networkManager.getPracticeService())
        vc.backHidden = true
        let navC = UINavigationController(rootViewController: vc)
        return navC
    }
    
    func createCoursesModule() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllCoursesVC") as AllCoursesViewController
        let networkManager = ModuleBuilder.resolver.resolve(type: NetworkServicesFactoryProtocol.self) as! NetworkServicesFactoryProtocol
        
        vc.presenter = AllCoursesPresenter(view: vc, networkFactory: networkManager)
        vc.backHidden = true
        let navC = UINavigationController(rootViewController: vc)
        return navC
    }
    
    func createProfileModule() -> UIViewController {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileVC") as ProfileViewController
        profileVC.presenter = ProfilePresenter(view: profileVC)
        let navC = UINavigationController(rootViewController: profileVC)
        return navC
    }
    
    func createCustomTestModule(vcIndex: Int, testIndex: Int) -> UIViewController{
        let cust = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTestVC") as CustomTestsViewController
        cust.vcIndex = vcIndex
        cust.testIndex = testIndex
        cust.presenter = CustomTestsPresenter(view: cust, questionIndex: vcIndex, testIndex: testIndex)
        return cust
    }
    
    func createMultipleChoiceDiary(vcIndex: Int) -> UIViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MultipleDiaryVC") as MultipleChoiceDiaryViewController
        vc.vcIndex = vcIndex
        vc.presenter = MultipleChoiceDiaryPresenter(view: vc, vcIndex: vcIndex)
        return vc
    }
    
    func createMoodModuleOne(mood: String, vcIndex: Int) -> UIViewController{
        let moodOneVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FirstQuestionVC") as FirstQuestionsViewController
        moodOneVC.vcIndex = vcIndex
        moodOneVC.presenter = FirstQuestionsPresenter(view: moodOneVC, currMood: mood)
        return moodOneVC
    }
    
    func createMoodModuleTwo(mood: String, vcIndex: Int) -> UIViewController{
        let moodTwoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondQuestionVC") as SecondQuestionsViewController
        moodTwoVC.vcIndex = vcIndex
        moodTwoVC.presenter = SecondQuestionsPresenter(view: moodTwoVC, currMood: mood)
        return moodTwoVC
    }
    
    func createPractice(info: PracticeInfoRKO, title: String, practiceName: String) -> [UIViewController]{
        var controllers = [UIViewController]()
        let vcCount = info.steps.count + 1
        for step in info.steps {
            print(step)
            switch step.type {
            case "TEXT":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TextExcVC") as TextExcerciseViewController
                //
                vc.presenter = TextExcercisePresenter(view: vc, currAudio: nil, id: info.id)
                //
                vc.vcCount = vcCount
                vc.vcIndex = vcCount - 1
                vc.titleText = title
                vc.excerciseName = practiceName
                vc.excerciseDescription = step.question
                
                controllers.append(vc)
            case "FILE":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "insertImageExcVC") as InsertImageExcerciseViewController
                //
                vc.presenter = InsertImageExcercisePresenter(view: vc, currAudio: nil)
                //
                vc.vcCount = vcCount
                vc.vcIndex = vcCount - 1
                vc.titleText = title
                vc.excerciseName = practiceName
                vc.excerciseDescription = step.question
                controllers.append(vc)
            case "LIST":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "gapsExcVC") as GapsExcerciseViewController
                vc.presenter = GapsExcercisePresenter(view: vc, currAudio: nil, currCode: "12", id: info.id)
                vc.vcCount = vcCount
                vc.vcIndex = vcCount - 1
                vc.titleText = title
                vc.excerciseName = practiceName
                vc.excerciseDescription = step.question
                controllers.append(vc)
            default:
                break
            }
        }
        return controllers
    }
    
    func createAnyPractic(info: [ExcerciseInfo], title: String, practicName: String) -> [UIViewController]{
        var controllers = [UIViewController]()
        let vcCount = info.count + 1
        let sort = info.sorted(by: {$1.number > $0.number})
        for token in sort{
            switch token.type {
            case "photo":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "insertImageExcVC") as InsertImageExcerciseViewController
                //
                vc.presenter = InsertImageExcercisePresenter(view: vc, currAudio: token.audio!)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                controllers.append(vc)
                
            case "note":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TextExcVC") as TextExcerciseViewController
                //
                vc.presenter = TextExcercisePresenter(view: vc, currAudio: token.audio, id: token.id)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                controllers.append(vc)
                
            case "illustration":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "pictureExcVC") as PictureExcerciseViewController
                //
                vc.presenter = TextExcercisePresenter(view: vc, currAudio: token.audio, id: token.id)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                //
                vc.imageId = token.image
                //
                controllers.append(vc)
            
            case "pattern":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "gapsExcVC") as GapsExcerciseViewController
                vc.presenter = GapsExcercisePresenter(view: vc, currAudio: token.audio, currCode: "12", id: token.id)
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = "Пожалуста, заполните данные пропуски: "
                controllers.append(vc)
                
            case "yes_no":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "YesNoExcVC") as YesNoExcerciseViewController
                //
                vc.presenter = TextExcercisePresenter(view: vc, currAudio: token.audio, id: token.id)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                controllers.append(vc)
            
            case "illustration_note":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TextPicVC") as TextPictureExcerciseViewController
                //
                vc.presenter = TextExcercisePresenter(view: vc, currAudio: token.audio, id: token.id)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                //
                vc.imageId = token.image ?? ""
                //
                controllers.append(vc)
                
            case "selection_single":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChoiceExcVC") as AnswerChoiceExcerciseViewController
                //
                vc.presenter = AnswerChoiceExcercisePresenter(view: vc, currAudio: token.audio, id: token.id, roughAnswers: token.answers!)
                //
                vc.vcCount = vcCount
                vc.vcIndex = Int(token.number)! - 1
                vc.titleText = title
                vc.excerciseName = practicName
                vc.excerciseDescription = token.description
                //

                //
                controllers.append(vc)
                
            default:
                let vc = UIViewController()
                controllers.append(vc)
            }
        }
        let finishVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "YesNoExcVC") as YesNoExcerciseViewController
        finishVC.finishVC = true
        finishVC.presenter = TextExcercisePresenter(view: finishVC, currAudio: "F724D03E-6748-46F4-B1F8-A5F242531DD0", id: "")
        finishVC.vcCount = vcCount
        finishVC.vcIndex = vcCount - 1
        finishVC.titleText = title
        finishVC.excerciseName = practicName
        finishVC.excerciseDescription = "Понравилось ли вам данное упражнение?"
        controllers.append(finishVC)
        return controllers
    }
}
