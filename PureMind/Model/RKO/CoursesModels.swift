//
//  CourcesModels.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 12.03.2023.
//

import Foundation

struct CourseRKO: Decodable {
    let id: String
    let is_paid: Bool
    let current_lesson: Int
    let name:  String
    let description: String
    let lessons: [String]
}

struct CoursesRKO: Decodable {
    let courses: [CourseRKO]
}

struct LectureRKO: Decodable {
    let id: String
    let name: String
    let url: String
}

struct QuestionRKO: Decodable {
    let id: String
    let name: String
    let question: String
}

struct CoursePracticeRKO: Decodable {
    let id: String
    let name: String
}

struct BookRKO: Decodable {
    let id: String
    let name: String
    let url: String
}

struct LessonRKO: Decodable {
    let id: String
    let name: String
    let lectures: [LectureRKO]
    let questions: [QuestionRKO]
    let practices: [CoursePracticeRKO]
    let books: [BookRKO]
}

struct CourseFullInfoRKO: Decodable {
    let id: String
    let name: String
    let current_lesson: Int?
    let progress: Float
    let description: String
    let lessons: [LessonRKO]
}
