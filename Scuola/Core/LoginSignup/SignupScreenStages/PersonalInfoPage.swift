//
//  PersonalInfoPage.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI

struct PersonalInfoPage: View {
    @Binding var name: String
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(){
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            TextField("Confirm Password", text: $confirmPassword)
            TextField("Name", text: $name)
            TextField("Username", text: $username)
        }
    }
}
