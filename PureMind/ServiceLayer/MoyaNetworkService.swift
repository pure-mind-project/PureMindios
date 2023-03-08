//
//  MoyaNetworkService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 07.03.2023.
//

import Foundation
import Moya
import Alamofire

enum AuthService {
    case authenticate(name: String, email: String, password: String)
    case register(name: String, email: String, password: String)
    case verify(email: String, code: String)
}

extension AuthService: TargetType {
        
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1")!
    }
    
    var path: String {
        switch self {
        case .authenticate:
            return "/auth/authenticate"
        case .register:
            return "/auth/register"
        case .verify:
            return "/user/verify"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .authenticate(let name, let email, let password), .register(let name, let email, let password):
            let data = try! JSONEncoder().encode(AuthInfo(email: email, name: name, password: password))
            return .requestData(data)
        case .verify(let email, let code):
            let data = try! JSONEncoder().encode(VerifyInfo(email: email, activationCode: code))
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}


struct AuthServiceManager {
    var provider = MoyaProvider<AuthService>()
    
    func registerUser(nickname: String, email: String, password: String,
                      completion: @escaping (Result<String, SessionError>) -> Void) {
        provider.request(.authenticate(name: nickname, email: email, password: password),
                         completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let token = try JSONDecoder().decode(Token.self, from: responce.data)
                    completion(.success(token.token))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func authenticateUser(nickname: String, email: String, password: String,
                          completion: @escaping (Result<String, SessionError>) -> Void) {
        provider.request(.authenticate(name: nickname, email: email, password: password),
                        completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let token = try JSONDecoder().decode(Token.self, from: responce.data)
                    completion(.success(token.token))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func verifyUser(email: String, code: String, completion: @escaping (Result<Int, SessionError>) -> Void) {
        provider.request(.verify(email: email, code: code), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let code = try JSONDecoder().decode(Int.self, from: responce.data)
                    if code != 200 {
                        completion(.failure(SessionError.serverError(code)))
                    }
                    completion(.success(code))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
}
