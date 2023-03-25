//
//  NetworkServicesManager.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 09.03.2023.
//

import Foundation

protocol NetworkServicesFactoryProtocol {
    func getCourcesService() -> CourcesServiceManager
    func getPracticeService() -> PracticeServiceManagerProtocol
    func getEveningDiaryService() -> EveningDiaryServiceManagerProtocol
    func getMorningDiaryService() -> MorningDiaryServiceManagerProtocol
    static func makeTokenHeader(token: String) -> [String:String]
}

class NetworkServicesFactory: NetworkServicesFactoryProtocol {
    internal init(token: String) {
        self.token = token
    }
    
    private let token: String
    
    public func getCourcesService() -> CourcesServiceManager {
        CourcesServiceManager(token: token)
    }
    
    public func getPracticeService() -> PracticeServiceManagerProtocol {
        PracticeServiceManager(token: token)
    }
    
    public func getEveningDiaryService() -> EveningDiaryServiceManagerProtocol {
        EveningDiaryServiceManager(token: token)
    }
    
    public func getMorningDiaryService() -> MorningDiaryServiceManagerProtocol {
        MorningDiaryServiceManager(token: token)
    }
    
    public static func makeTokenHeader(token: String) -> [String:String] {
        return ["Authorization":"Bearer \(token)"]
    }
}

class Resolver {
    public static let shared = Resolver()
    private var objects: [String:Any] = [:]
    
    public func register<Service>(type: Service.Type = Service.self, _ factory: () -> Service) {
        let res = factory()
        objects[String(describing: type)] = res
        print(objects)
    }
    
    public func resolve<T>(type: T.Type) -> Any? {
        print(String(describing: type))
        print(objects)
        return objects[String(describing: type)]
    }
}
