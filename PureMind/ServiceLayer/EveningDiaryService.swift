//
//  EveningDiaryService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 25.03.2023.
//

import Foundation
import Moya

enum EveningDiaryService {
    case getDiary(token: String)
    case uploadDiaryAnswer(token: String, answer: DiaryAnswerTitle)
    case getDiaryAnswersPeriod(token: String, start: Int64, end: Int64)
    case getDiaryWithID(token: String, id: String)
}

extension EveningDiaryService: TargetType {
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1/evening_diary")!
    }
    
    var path: String {
        switch self {
        case .getDiary(_), .uploadDiaryAnswer(_, _):
            return ""
        case .getDiaryAnswersPeriod(_, let start, let end):
            return "/history?start_date=\(start.description)&end_date=\(end.description)"
        case .getDiaryWithID(_, let id):
            return "\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDiaryAnswersPeriod, .getDiary, .getDiaryWithID:
            return .get
        case .uploadDiaryAnswer:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getDiary, .getDiaryAnswersPeriod, .getDiaryWithID:
            return .requestPlain
        case .uploadDiaryAnswer(_, let answer):
            let data = try! JSONEncoder().encode(answer)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getDiaryAnswersPeriod(let token, _, _), .uploadDiaryAnswer(let token, _),
                .getDiary(let token), .getDiaryWithID(let token, _):
            return NetworkServicesFactory.makeTokenHeader(token: token)
        }
    }
}

protocol EveningDiaryServiceManagerProtocol {
    func getDiary(completion:  @escaping (Result<EveningDiaryTechniques, SessionError>) -> Void)
    func getDiaryAnswersPeriod(start: Date, end: Date , completion: @escaping (Result<DiaryPeriodAnswers, SessionError>) -> Void)
    func uploadDiaryAnswer(answer: DiaryAnswerTitle, completion: @escaping (Result<Void, SessionError>) -> Void)
    func getDiaryID(id: String, completion: @escaping (Result<EveningDiary, SessionError>) -> Void)
}

struct EveningDiaryServiceManager: EveningDiaryServiceManagerProtocol {
    public init(token:  String) {
        self.token = token
    }
    
    private let decoder = JSONDecoder()
    private let token: String
    private let provider = MoyaProvider<EveningDiaryService>()
    
    func getDiary(completion:  @escaping (Result<EveningDiaryTechniques, SessionError>) -> Void) {
        provider.request(.getDiary(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(EveningDiaryTechniques.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getDiaryAnswersPeriod(start: Date, end: Date , completion: @escaping (Result<DiaryPeriodAnswers, SessionError>) -> Void) {
        let startDate = Int64(start.timeIntervalSince1970)
        let endDate = Int64(end.timeIntervalSince1970)
        provider.request(.getDiaryAnswersPeriod(token: token, start: startDate, end: endDate), completion: { result in
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

    func uploadDiaryAnswer(answer: DiaryAnswerTitle, completion: @escaping (Result<Void, SessionError>) -> Void) {
        provider.request(.uploadDiaryAnswer(token: token, answer: answer), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    if responce.statusCode <= 300 {
                        completion(.success(Void()))
                    }
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getDiaryID(id: String, completion: @escaping (Result<EveningDiary, SessionError>) -> Void) {
        provider.request(.getDiaryWithID(token: token, id: id), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(EveningDiary.self, from: responce.data)
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
