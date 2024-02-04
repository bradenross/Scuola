//
//  CredentialsInputPage.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import SwiftUI

struct CredentialsInputPage: View {
    @Binding var title: String
    @Binding var signupInfo: SignupInfo
    @State var confirmPassword: String = ""
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "envelope.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Email", text: $signupInfo.email)
                        .keyboardType(UIKeyboardType.emailAddress)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "lock.open.fill")
                    .foregroundColor(.white)
                VStack(){
                    SecureField("Password", text: $signupInfo.password)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                VStack(){
                    SecureField("Confirm Password", text: $signupInfo.confirmPassword)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
        }
        .onAppear{
            title = "Create Your Account"
        }
    }
}
