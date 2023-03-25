//
//  QuestionsAndAffirmationsService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 25.03.2023.
//

import Foundation
import Moya

enum QuestionsAndAffirmationsService {
    case getQuestion(token: String)
    case uploadAnswer(token: String, answer: DiaryAnswerID)
    case getAnswersPeriod(token: String, start: Int64, end: Int64)
    case getAffirmation(token: String)
}

extension QuestionsAndAffirmationsService: TargetType {
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .getQuestion(_), .uploadAnswer(_, _):
            return "ask_yourself"
        case .getAnswersPeriod(_, let start, let end):
            return "ask_yourself/history?start_date=\(start.description)&end_date=\(end.description)"
        case .getAffirmation(_):
            return "affirmation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAnswersPeriod, .getQuestion, .getAffirmation:
            return .get
        case .uploadAnswer:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getQuestion, .getAnswersPeriod, .getAffirmation:
            return .requestPlain
        case .uploadAnswer(_, let answer):
            let data = try! JSONEncoder().encode(answer)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAnswersPeriod(let token, _, _), .uploadAnswer(let token, _),
                .getQuestion(let token), .getAffirmation(let token):
            return NetworkServicesFactory.makeTokenHeader(token: token)
        }
    }
}

protocol QuestionsAndAffirmationsServiceProtocol {
    func getQuestion(completion:  @escaping (Result<DiaryAnswerID, SessionError>) -> Void)
    func getAnswersPeriod(start: Date, end: Date , completion: @escaping (Result<DiaryPeriodAnswers, SessionError>) -> Void)
    func uploadAnswer(answer: DiaryAnswerID, completion: @escaping (Result<Void, SessionError>) -> Void)
    func getAffirmation(completion: @escaping (Result<Affirmation, SessionError>) -> Void)
}

struct QuestionsAndAffirmationsServiceManager: QuestionsAndAffirmationsServiceProtocol {
    public init(token:  String) {
        self.token = token
    }
    
    private let decoder = JSONDecoder()
    private let token: String
    private let provider = MoyaProvider<QuestionsAndAffirmationsService>()
    
    func getQuestion(completion:  @escaping (Result<DiaryAnswerID, SessionError>) -> Void) {
        provider.request(.getQuestion(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(DiaryAnswerID.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getAnswersPeriod(start: Date, end: Date , completion: @escaping (Result<DiaryPeriodAnswers, SessionError>) -> Void) {
        let startDate = Int64(start.timeIntervalSince1970)
        let endDate = Int64(end.timeIntervalSince1970)
        provider.request(.getAnswersPeriod(token: token, start: startDate, end: endDate), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(DiaryPeriodAnswers.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }

    func uploadAnswer(answer: DiaryAnswerID, completion: @escaping (Result<Void, SessionError>) -> Void) {
        provider.request(.uploadAnswer(token: token, answer: answer), completion: { result in
            switch result {
            case .success(let responce):
                if responce.statusCode <= 300 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(SessionError.invalidUrl))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getAffirmation(completion: @escaping (Result<Affirmation, SessionError>) -> Void) {
        provider.request(.getAffirmation(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(Affirmation.self, from: responce.data)
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
