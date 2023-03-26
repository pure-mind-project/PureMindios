//
//  MoodService.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 26.03.2023.
//

import Foundation
import Moya

enum MoodTrackerService {
    case getMoodLastWeek(token: String)
    case uploadMoodAnswer(token: String, answer: AnswersForMood)
    case getMoodHistoryPeriod(token: String, start: Int64, end: Int64)
    case getMoodPercentsPeriod(token: String, start: Int64, end: Int64)
    case getMoodWithID(token: String, id: String)
    case getQuestionForMood(token: String, mood: Int)
}

extension MoodTrackerService: TargetType {
    var baseURL: URL {
        return URL(string: "http://62.109.30.122:8081/api/v1/mood_tracker")!
    }
    
    var path: String {
        switch self {
        case .getMoodLastWeek(_):
            return "/last_week"
        case .uploadMoodAnswer(_, _):
            return "/questions"
        case .getMoodHistoryPeriod(_, let start, let end):
            return "/history?start_date=\(start.description)&end_date=\(end.description)"
        case .getMoodPercentsPeriod(_, let start, let end):
            return "/history?start_date=\(start.description)&end_date=\(end.description)"
        case .getMoodWithID(_, let id):
            return "/history/\(id)"
        case .getQuestionForMood(_, let mood):
            return "/questions?mood=\(mood.description)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMoodHistoryPeriod, .getMoodLastWeek, .getMoodWithID, .getMoodPercentsPeriod, .getQuestionForMood:
            return .get
        case .uploadMoodAnswer:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getMoodLastWeek, .getMoodHistoryPeriod, .getMoodWithID, .getQuestionForMood, .getMoodPercentsPeriod:
            return .requestPlain
        case .uploadMoodAnswer(_, let answer):
            let data = try! JSONEncoder().encode(answer)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMoodHistoryPeriod(let token, _, _), .uploadMoodAnswer(let token, _),
                .getMoodLastWeek(let token), .getMoodWithID(let token, _),
                .getMoodPercentsPeriod(token: let token, _,_), .getQuestionForMood(token: let token, _):
            return NetworkServicesFactory.makeTokenHeader(token: token)
        }
    }
}

protocol MoodTrackerServiceManagerProtocol {
    func getMoodLastWeeek(completion:  @escaping (Result<DaysMood, SessionError>) -> Void)
    func getMoodHistoryPeriod(start: Date, end: Date , completion: @escaping (Result<Moods, SessionError>) -> Void)
    func getMoodPercentPeriod(start: Date, end: Date , completion: @escaping (Result<MoodPercents, SessionError>) -> Void)
    func uploadMoodAnswer(answer: AnswersForMood, completion: @escaping (Result<Void, SessionError>) -> Void)
    func getMoodWithID(id: String, completion: @escaping (Result<MoodHistory, SessionError>) -> Void)
    func getQuestionForMood(mood: Int, completion: @escaping (Result<MoodQuestionsWithMultipleAnswers, SessionError>) -> Void)
}

struct MoodTrackerServiceManager: MoodTrackerServiceManagerProtocol {
    public init(token:  String) {
        self.token = token
    }
    
    private let decoder = JSONDecoder()
    private let token: String
    private let provider = MoyaProvider<MoodTrackerService>()
    
    func getMoodLastWeeek(completion:  @escaping (Result<DaysMood, SessionError>) -> Void) {
        provider.request(.getMoodLastWeek(token: token), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(DaysMood.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getMoodHistoryPeriod(start: Date, end: Date , completion: @escaping (Result<Moods, SessionError>) -> Void) {
        let startDate = Int64(start.timeIntervalSince1970)
        let endDate = Int64(end.timeIntervalSince1970)
        provider.request(.getMoodHistoryPeriod(token: token, start: startDate, end: endDate), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(Moods.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getMoodPercentPeriod(start: Date, end: Date , completion: @escaping (Result<MoodPercents, SessionError>) -> Void) {
        let startDate = Int64(start.timeIntervalSince1970)
        let endDate = Int64(end.timeIntervalSince1970)
        provider.request(.getMoodPercentsPeriod(token: token, start: startDate, end: endDate), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(MoodPercents.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }

    func uploadMoodAnswer(answer: AnswersForMood, completion: @escaping (Result<Void, SessionError>) -> Void) {
        provider.request(.uploadMoodAnswer(token: token, answer: answer), completion: { result in
            switch result {
            case .success(let responce):
                if responce.statusCode <= 300 {
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getMoodWithID(id: String, completion: @escaping (Result<MoodHistory, SessionError>) -> Void) {
        provider.request(.getMoodWithID(token: token, id: id), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(MoodHistory.self, from: responce.data)
                    completion(.success(practices))
                } catch (let error) {
                    completion(.failure(SessionError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(SessionError.other(error)))
            }
        })
    }
    
    func getQuestionForMood(mood: Int, completion: @escaping (Result<MoodQuestionsWithMultipleAnswers, SessionError>) -> Void) {
        provider.request(.getQuestionForMood(token: token, mood: mood), completion: { result in
            switch result {
            case .success(let responce):
                do {
                    let practices = try self.decoder.decode(MoodQuestionsWithMultipleAnswers.self, from: responce.data)
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
