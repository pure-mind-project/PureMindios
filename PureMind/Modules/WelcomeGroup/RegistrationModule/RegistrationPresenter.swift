//
//  RegistrationPresenter.swift
//  PureMind
//
//  Created by Клим on 09.07.2021.
//

import UIKit


protocol RegistrationPresenterProtocol{
    init(view: RegistrationViewProtocol)
    func infoValidation(nickname: String, email: String, password: String) -> String
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func performRegistration(nickname: String, email: String, password: String) 
}

class RegistrationPresenter: RegistrationPresenterProtocol{
    
    weak var view: RegistrationViewProtocol?
    let networkService = NetworkService.shared
    let cacheService = CachingService.shared
    required init(view: RegistrationViewProtocol) {
        self.view = view
    }
    
    func infoValidation(nickname: String, email: String, password: String) -> String{
        if email == "" || nickname == "" || password == ""{
            return "Вы не заполнили все поля"
        }
        //var clearEmail = stringClear(str: email)
        //clearEmail = clearEmail.replacingOccurrences(of: "-", with: "")
        //if clearEmail.latinCharactersOnly == false {
          //  return "Адрес почты должен быть на латинице»"
        //}
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
    
    func performRegistration(nickname: String, email: String, password: String) {
        let service = AuthServiceManager()
        service.registerUser(nickname: nickname, email: email, password: password, completion: { [weak self] (result) in
            switch result {
            case let .success(token):
                print(token)
                self?.networkService.apiKey = token
                self?.cacheService.cacheInfo(UserInfo(login: email, password: password, token: token))
                self?.view?.registerSuccess()
                
            case .failure(_):
                self?.view?.registerAlert(text: "Зарегестрироваться не удалось. Пожалуйста, проверьте ваши данные и попробуйте снова")

            }
        })
                             
//        networkService.registerUser(nickname: nickname, email: email, password: password) {[weak self] (result) in
//            switch result{
//            case let .success(token):
//                self?.networkService.apiKey = token
//                self?.cacheService.cacheInfo(UserInfo(login: email, password: password, token: token))
//                self?.view?.registerSuccess()
//
//            case .failure(_):
//                self?.view?.registerAlert(text: "Зарегестрироваться не удалось. Пожалуйста, проверьте ваши данные и попробуйте снова")
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
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "loginSegue":
            guard let vc = segue.destination as? LoginViewController
            else {fatalError("invalid data passed")}
            vc.presenter = LoginPresenter(view: vc)
            
        case "policiesShortSegue":
            guard let vc = segue.destination as? PoliciesShortViewController
            else {fatalError("invalid data passed")}
            vc.presenter = PoliciesShortPresenter(view: vc)
        
        case "themesSegue":
            guard let vc = segue.destination as? ThemesViewController
            else {fatalError("invalid data passed")}
            vc.presenter = ThemesPresenter(view: vc)
        
        case "skipSegue":
            guard segue.destination is MainTabBarController
            else {fatalError("invalid data passed")}
            
        default:
            break
        }
    }
    
}
