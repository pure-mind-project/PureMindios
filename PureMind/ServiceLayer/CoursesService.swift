//
//  CourcesService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 09.03.2023.
//

import Foundation
import Moya

enum CoursesService {
    case getCourses(token: String)
    case getCourseInfo(id: String, token: String)
    case buyCourse(id: String, token: String)
}

extension CoursesService: TargetType {
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1/courses")!
    }
    
    var path: String {
        switch self {
        case .getCourses:
            return ""
        case .buyCourse(let id, _):
            return "/\(id)"
        case .getCourseInfo(let id, _):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCourses, .getCourseInfo:
            return .get
        case .buyCourse:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCourses, .getCourseInfo:
            return .requestPlain
        case .buyCourse:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCourses(let token), .getCourseInfo(_, let token), .buyCourse(_, let token):
            // var temp = ["Content-Type": "application/json", "Accept": "application/json"]
            return NetworkServicesFactory.makeTokenHeader(token: token)
        }
    }
}

protocol CoursesServiceManagerProtocol {
    func getCourses(completion: @escaping (Result<CoursesRKO, SessionError>) ->  Void)
    func getCourseInfo(courseID: String, completion: @escaping (Result<CourseFullInfoRKO, SessionError>) ->  Void)
}

class CourcesServiceManager: CoursesServiceManagerProtocol {
    public init(token:  String) {
        self.token = token
    }
    
    private let decoder = JSONDecoder()
    private let token: String
    private let provider = MoyaProvider<CoursesService>()
    
    public func getCourses(completion: @escaping (Result<CoursesRKO, SessionError>) ->  Void) {
        provider.request(.getCourses(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(CoursesRKO.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    public func getCourseInfo(courseID: String, completion: @escaping (Result<CourseFullInfoRKO, SessionError>) ->  Void) {
        provider.request(.getCourseInfo(id: courseID, token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(CourseFullInfoRKO.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
}
