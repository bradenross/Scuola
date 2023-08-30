//
//  BrandedTextField.swift
//  Scuola
//
//  Created by Braden Ross on 8/29/23.
//

import SwiftUI

struct BrandedTextField: View {
    @Binding var input: String
    var placeholder: String
    var symbol: String
    
    var body: some View {
        HStack(){
            Image(systemName: symbol)
                .foregroundColor(BrandedColor.text)
            VStack(){
                SecureField(placeholder, text: $input)
                Divider()
                    .overlay(BrandedColor.text)
            }
        }
        .padding(.vertical, 10)
    }
}
