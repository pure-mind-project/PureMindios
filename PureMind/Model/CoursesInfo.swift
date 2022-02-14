//
//  CoursesInfo.swift
//  PureMind
//
//  Created by Клим on 16.01.2022.
//

import Foundation

struct CoursesInfo: Decodable{
    var id: String
    var name: String
    var description: String
}

struct LessonInfo: Decodable{
    var name: String
    var reflexiveQuestions: [ReflexInfo]
    var practices: [ReflexInfo]
    var video: String?
    var additionalLiterature: [BookInfo]?
}

struct BookInfo: Decodable {
    var text: String
}

struct ShortLessonInfo: Decodable{
    var id: String
    var name: String
}

struct ReflexInfo: Decodable{
    var name: String?
    var text: String
}
