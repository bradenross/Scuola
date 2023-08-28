//
//  BirthdatePage.swift
//  Scuola
//
//  Created by Braden Ross on 8/21/23.
//

import SwiftUI

struct BirthdatePage: View {
    @Binding var birthdate: Date

    var body: some View {
        VStack(){
            Text("When were you born?")
            DatePicker("Birthdate", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
        .padding(15)
    }
}
