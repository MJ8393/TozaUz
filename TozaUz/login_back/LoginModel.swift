//
//  LoginModel.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import Foundation

struct User: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let lastLogin: String?
    let role: String
    let isActive: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case lastLogin = "last_login"
        case role
        case isActive = "is_active"
    }
}

struct DeleteAuth: Decodable {
    let detail: String
}
struct AuthResponse: Decodable {
    let token: String
    let id: Int
    let phoneNumber: String
    let firstName: String
    let role: String
    
    private enum CodingKeys: String, CodingKey {
        case token
        case id
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case role
    }
}

struct PasswordUpdateResponse: Decodable {
    let message: String
}


struct PasswordUpdateInfoResponse: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [ResultInfo]?
    let amountSum: Int?
    
    private enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
        case amountSum = "amount__sum"
    }
}

struct ResultInfo: Decodable {
    let id: Int
    let createdAt: String
    let admin: AdminInfo
    let amount: Int
    let card: String
    let cardName: String
    let user: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case admin
        case amount
        case card
        case cardName = "card_name"
        case user
    }
}

struct AdminInfo: Decodable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let phoneNumber: String
    let role: String
    let isActive: Bool
    let categories: [String]
    let carNumber: String?
    let isAdmin: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case role
        case isActive = "is_active"
        case categories
        case carNumber = "car_number"
        case isAdmin = "is_admin"
    }
}


// xxx

struct MobileEarningListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [MobileEarning]
    let totalCat: [TotalCat]
    
    private enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
        case totalCat = "total_cat"
    }
}

struct MobileEarning: Decodable {
    let id: Int
    let tarrif: String
    let amount: Int
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case tarrif
        case amount
        case createdAt = "created_at"
    }
}

struct TotalCat: Decodable {
    let tarrif: String
    let count: Int
}

