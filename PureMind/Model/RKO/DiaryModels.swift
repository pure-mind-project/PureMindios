//
//  DiaryModels.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 24.03.2023.
//

import Foundation

struct DiaryAnswerTitle: Codable {
    var title: String
    var answer: String
}

struct DiaryAnswerID: Codable {
    var question_id: String
    var answer: String
}

struct DiaryDateAnswer: Codable {
    var title: String
    var answer: String
    var date: Int64
}

struct DiaryPeriodAnswers:  Codable {
    var start_date: Int64
    var end_date: Int64
    var answers: [DiaryDateAnswer]
}

struct DiaryStep: Codable {
    var type: String
    var image_url: String
    var text: String
}

struct DiarySteps: Codable {
    var is_new: Bool
    var steps: [DiaryStep]
}

struct EveningDiaryTechnique: Codable {
    var is_new: Bool
    var id: String
    var title: String
}

struct EveningDiaryTechniques: Codable {
    var techniques: [EveningDiaryTechnique]
}

struct EveningDiary: Codable {
    var id: String
    var steps: [DiarySteps]
}

struct DiaryQuestion: Codable {
    var qustion_id: String
    var qustion: String
    var is_new: Bool
}

struct Affirmation: Codable {
    var affirmation: String
}
