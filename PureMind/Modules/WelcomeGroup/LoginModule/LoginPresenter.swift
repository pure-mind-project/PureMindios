//
//  LoginPresenter.swift
//  PureMind
//
//  Created by Клим on 10.07.2021.
//

import UIKit

protocol LoginPresenterProtocol{
    init(view: LoginViewProtocol)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func infoValidation(email: String, password: String) -> String
    func performLogin(email: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol{
    weak var view: LoginViewProtocol?
    let networkService = NetworkService.shared
    let cacheService = CachingService.shared
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
    
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "loginToMenuSegue":
            guard segue.destination is MainTabBarController 
            else {fatalError("invalid data passed")}
            
        case "restorePasswordSegue":
            guard let vc = segue.destination as? NoPasswordViewController
            else {fatalError("invalid data passed")}
            vc.presenter = NoPasswordPresenter(view: vc)

            
        default:
            break
        }
    }
    
    func infoValidation(email: String, password: String) -> String {
        if email == "" || password == ""{
            return "Вы не заполнили все поля"
        }
        let clearEmail = stringClear(str: email)
        if clearEmail.latinCharactersOnly == false {
            return "Адрес почты должен быть на латинице»"
        }
        if email.contains("@") == false || email.contains(".") == false {
            return "Некорректный формат почты"
        }
        if password.count < 8 {
            return  "Минимальная длина пароля 8 символов"
        }
        
        if password.russianOnly.count != 0{
            return "Пароль должен быть на латинице»"
        }
        
        let decimalChars = CharacterSet.decimalDigits
        let letters = CharacterSet.letters
        let decimalRange = password.rangeOfCharacter(from: decimalChars)
        let letterRange = password.rangeOfCharacter(from: letters)
        
        if decimalRange == nil || letterRange == nil{
            return "Пароль должен содержать хотя бы одну цифру или букву"
        }
        return "pass"
    }
    
    func performLogin(email: String, password: String) {
        let service = AuthServiceManager()
        
        service.authenticateUser(email: email, password: password, completion: { result in
            switch result {
            case .success(let token):
                ModuleBuilder.registerInResolver(type: NetworkServicesFactoryProtocol.self, {
                    return NetworkServicesFactory(token: token)
                })
            case .failure(let error):
                print(error)
            }
            
            self.view?.loginSuccess()
        })
//        networkService.logIN(login: email, password: password) { (result) in
//            switch result{
//            case let .success(token):
//                self.networkService.apiKey = token
//                self.cacheService.cacheInfo(UserInfo(login: email, password: password, token: token))
//                self.view?.loginSuccess()
//
//            case .failure(_):
//                self.view?.loginAlert(text: "Войти в систему не удалось. Пожалуйста, проверьте логин и пароль и попробуйте снова")
//            }
//        }
    }
    
    func stringClear(str: String) -> String{
        var newStr = ""
        for char in str{
            if char != "@" && char != "."{
                newStr.append(char)
            }
        }
        return newStr
    }
    
    
}
