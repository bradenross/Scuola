//
//  AuthenticationUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import Foundation

protocol AuthenticationUseCase {
    func login(email: String, password: String)
    func signOut()
    func createNewUser(user: Account)
}
