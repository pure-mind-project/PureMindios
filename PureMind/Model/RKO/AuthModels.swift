//
//  AuthModels.swift
//  PureMind
//
//  Created by Stepan Ostapenko on 07.03.2023.
//

import Foundation

struct AuthInfo: Codable {
    internal init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var email: String
    var password: String
}

struct RegistrationInfo: Codable {
    var email: String
    var password: String
    var name: String
}

struct VerifyInfo: Codable {
    internal init(email: String, activationCode: String) {
        self.email = email
        self.activationCode = activationCode
    }
    
    var email: String
    var activationCode: String
}

struct Token: Codable {
    internal init(token: String) {
        self.token = token
    }
    
    var token: String
}
