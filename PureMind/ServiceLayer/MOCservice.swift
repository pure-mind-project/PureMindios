//
//  MOCservice.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 19.03.2023.
//

import Foundation

class MOCService {
    static func getLessons() -> [LessonInfo] {
        let course1 = LessonInfo(name: "Course1", reflexiveQuestions:
                                    [ReflexInfo(name: "question1", text: "..."), ReflexInfo(name: "question2", text: "..."), ReflexInfo(name: "question3", text: "...")],
                                 practices: [ReflexInfo(name: "practice1", text: "..."), ReflexInfo(name: "practice2", text: "..."), ReflexInfo(name: "practice3", text: "...")])
        
        let course2 = LessonInfo(name: "Course2", reflexiveQuestions:
                                    [ReflexInfo(name: "question1", text: "..."), ReflexInfo(name: "question2", text: "..."), ReflexInfo(name: "question3", text: "...")],
                                 practices: [ReflexInfo(name: "practice1", text: "..."), ReflexInfo(name: "practice2", text: "..."), ReflexInfo(name: "practice3", text: "...")])
        return [course1, course2]
    }
    
    static func getCoursesInfo() -> [CoursesInfo] {
        let course1 = CoursesInfo(id: "1", name: "course1", description: "This is course 1")
        let course2 = CoursesInfo(id: "2", name: "course2", description: "This is course 2")
        return [course1, course2]
    }
    
    static func getShortLessonInfo() -> [ShortLessonInfo] {
        let lesson1 = ShortLessonInfo(id: "1", name: "lesson1")
        let lesson2 = ShortLessonInfo(id: "2", name: "lesson2")
        return [lesson1, lesson2]
    }
}
