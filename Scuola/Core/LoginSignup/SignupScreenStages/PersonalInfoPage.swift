//
//  PersonalInfoPage.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI

struct PersonalInfoPage: View {
    @Binding var firstName: String
    
    var body: some View {
        VStack(){
            TextField("First Name", text: $firstName)
        }
    }
}
