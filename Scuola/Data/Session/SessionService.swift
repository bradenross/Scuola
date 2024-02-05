//
//  SessionService.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

enum SessionState {
    case loggedIn
    case loggedOut
}

struct UserSessionDetails {
    let firstName: String
    let lastName: String
    let occupation: String
    let gender: String
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: UserSessionDetails? { get }
    init()
    func logout()
}
