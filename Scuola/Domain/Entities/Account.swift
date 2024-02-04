//
//  Account.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import Foundation

struct Account: Identifiable, Codable {
    var id: String
    var username: String
    var name: String
    var bio: String
    var followers: Int
    var following: Int
    var birthdate: Date
    var userType: String
    var verified: Bool
    var live: Bool
    var picture: String
    
    enum CodingKeys: String, CodingKey {
            case id
            case username
            case name
            case bio
            case followers
            case following
            case birthdate
            case userType
            case verified
            case live
            case picture
        }
}
