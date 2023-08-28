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
    
    var body: some View {
        VStack(){
            TextField("Name", text: $name)
            TextField("Username", text: $username)
        }
    }
}
