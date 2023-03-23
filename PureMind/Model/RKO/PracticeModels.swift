//
//  PracticeModels.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 08.03.2023.
//

import Foundation

struct PracticeRKO: Codable {
    internal init(id: String, name: String, techniques: [String]) {
        self.id = id
        self.name = name
        self.techniques = techniques
    }
    
    let id: String
    let name: String
    let techniques: [String]
}

struct PracticesRKO: Codable {
    internal init(practices: [PracticeRKO]) {
        self.practices = practices
    }
    
    let practices: [PracticeRKO]
}

struct StepRKO: Codable {
    internal init(type: String, questions: String) {
        self.type = type
        self.question = questions
    }
    
    let type: String
    let question: String
}

struct PracticeInfoRKO: Codable {
    internal init(id: String, name: String, imageUrl: String, steps: [StepRKO]) {
        self.id = id
        self.name = name
        self.image_url = imageUrl
        self.steps = steps
    }
    
    let id: String
    let name: String
    let image_url: String
    let steps: [StepRKO]
}

struct PracticeFullInfoRKO: Codable {
    internal init(id: String, name: String, techniques: [PracticeInfoRKO]) {
        self.id = id
        self.name = name
        self.techniques = techniques
    }
    
    let id: String
    let name: String
    let techniques: [PracticeInfoRKO]
}
