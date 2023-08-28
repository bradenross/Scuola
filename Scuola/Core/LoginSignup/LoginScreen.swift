//
//  LoginScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State var errorPopup: Bool = false
    
    var body: some View {
        NavigationView(){
            VStack {
                Spacer()
                Image("ScuolaLogoMock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                Spacer()
                VStack {
                    HStack(){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                        VStack(){
                            TextField("Email", text: $emailInput)
                                .keyboardType(UIKeyboardType.emailAddress)
                                .foregroundColor(.white)
                            Divider()
                                .overlay(.white)
                        }
                    }
                    .padding(.vertical, 10)
                    HStack(){
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                        VStack(){
                            SecureField("Password", text: $passwordInput)
                            Divider()
                                .overlay(.white)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 25)
                Spacer()
                VStack {
                    
                    Button(action: {
                        Task{
                            FBAuth().login(email: emailInput, password: passwordInput)
                        }
                    }) {
                        Text("Login")
                            .bold()
                            .frame(maxWidth: 300, maxHeight: 50)
                            .background(.white)
                            .foregroundColor(BrandedColor.color1)
                            .cornerRadius(100)
                    }
                        
                    
                    Button(action: {}) {
                            NavigationLink(destination: SignupScreen()) {
                                Text("Sign Up")
                                    .bold()
                                    .frame(maxWidth: 300, maxHeight: 50)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                        }
                        
                }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BrandedColor.backgroundGradient)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
