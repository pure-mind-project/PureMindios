//
//  PracticeService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 08.03.2023.
//

import Foundation
import Moya

enum PracticeService {
    case getPractices(token: String)
    case getPracticesInfo(id: String, token: String)
}

extension PracticeService: TargetType {
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1/practices")!
    }
    
    var path: String {
        switch self {
        case .getPractices:
            return ""
        case .getPracticesInfo(let id, _):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getPractices, .getPracticesInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPractices(let token), .getPracticesInfo( _, let token):
            return NetworkServicesFactory.makeTokenHeader(token: token)
        }
    }
}

protocol PracticeServiceManagerProtocol {
    func getPractices(completion: @escaping (Result<PracticesRKO, SessionError>) ->  Void)
    func getPracticeInfo(practiceId: String, completion: @escaping (Result<PracticeFullInfoRKO, SessionError>) -> Void)
}

struct PracticeServiceManager: PracticeServiceManagerProtocol {
    public init(token:  String) {
        self.token = token
    }
    
    private let decoder = JSONDecoder()
    private let token: String
    private let provider = MoyaProvider<PracticeService>()
    
    public func getPractices(completion: @escaping (Result<PracticesRKO, SessionError>) ->  Void) {
        provider.request(.getPractices(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(PracticesRKO.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    public func getPracticeInfo(practiceId: String, completion: @escaping (Result<PracticeFullInfoRKO, SessionError>) -> Void) {
        provider.request(.getPracticesInfo(id: practiceId, token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practice = try self.decoder.decode(PracticeFullInfoRKO.self, from: responce.data)
                    completion(.success(practice))
                } catch (let error) {
                    print(error)
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
}
