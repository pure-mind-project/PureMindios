//
//  SceneDelegate.swift
//  PureMind
//
//  Created by Клим on 06.07.2021.
//

import UIKit
import YandexMobileMetrica

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        let mod = ModuleBuilder()
        if CachingService.shared.checkUserInfo() == false{
            window?.rootViewController = mod.createWelcomeModule()
            //window?.rootViewController = mod.createTabModule()
            window?.makeKeyAndVisible()
            
        }
        else{
            let configuration = YMMYandexMetricaConfiguration.init(apiKey: "cf14588a-3b7f-4f19-9978-79ee67b61f5c")
            YMMYandexMetrica.activate(with: configuration!)
            let params : [AnyHashable : Any] = ["didEnterApp": "True"]
            YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
                print("REPORT ERROR: %@", error.localizedDescription)
            })
            CachingService.shared.getInfo {[weak self] (result) in
                NetworkService.shared.logIN(login: result!.login, password: result!.password) { result in
                    switch result{
                    case let .success(token):
                        NetworkService.shared.apiKey = token
                        self?.window?.rootViewController = mod.createTabModule()
                        self?.window?.makeKeyAndVisible()
                        
                    case .failure(_):
                        self?.window?.rootViewController = mod.createWelcomeModule()
                        self?.window?.makeKeyAndVisible()
                    }
            }
            }
        }
    }
    
    func switchControllers(viewControllerToBeDismissed:UIViewController, controllerToBePresented:UIViewController) {
            if (viewControllerToBeDismissed.isViewLoaded && (viewControllerToBeDismissed.view.window != nil)) {
                // viewControllerToBeDismissed is visible
                //First dismiss and then load your new presented controller
                viewControllerToBeDismissed.dismiss(animated: false, completion: {
                    self.window?.rootViewController?.present(controllerToBePresented, animated: true, completion: nil)
                })
            } else {
            }
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

