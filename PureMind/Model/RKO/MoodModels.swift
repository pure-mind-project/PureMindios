//
//  MoodModels.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 26.03.2023.
//

import Foundation

struct DateMood: Codable {
    var date: Int64
    var mood: Int
}

struct DaysMood:  Codable {
    var days: [DaysMood]
}

struct MoodFloat: Codable {
    var mood: Int
    var value: Float
}

struct MoodPercents:  Codable {
    var percents:  [MoodFloat]
}

struct MoodDateId: Codable{
    var mood:  Int
    var date: Int64
    var id: String
}

struct Moods:  Codable {
    var moods: [MoodDateId]
}

struct MoodQuestionInfo: Codable {
    var question: String
    var answer: String
}

struct MoodHistory: Codable {
    var mood: Int
    var date: Int64
    var answers: [MoodQuestionInfo]
}

struct MoodQuestionMultipleAnswers: Codable {
    var id: String
    var type: String
    var question: String
    var answers: [String]
}

struct MoodQuestionsWithMultipleAnswers: Codable {
    var questions: [MoodQuestionMultipleAnswers]
}

struct AnswersForMood: Codable {
    var mood: Int
    var answers: [MoodQuestionInfo]
}

