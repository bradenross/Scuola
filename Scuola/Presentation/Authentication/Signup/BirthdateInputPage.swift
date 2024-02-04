//
//  BirthdateInputPage.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import SwiftUI

struct BirthdateInputPage: View {
    @Binding var title: String
    @Binding var signupInfo: SignupInfo
    
    var body: some View {
        VStack(){
            DatePicker("Birthdate", selection: $signupInfo.birthdate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .tint(.white)
        }
        .onAppear{
            title = "When Were You Born?"
        }
        .padding(15)
    }
}
