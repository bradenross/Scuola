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
    
    @State var animateGradient: Bool = false
    @State var gradientAngle: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack(){
                Text("Welcome Back!")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            .padding(.horizontal, 25)
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
                
                ScuolaButton(title: "Login", action: {
                    Task{
                        FBAuth().login(email: emailInput, password: passwordInput)
                    }
                })
                
                ScuolaButton(title: "Back", type: "secondary", action: {
                    presentationMode.wrappedValue.dismiss()
                })
                    
            }
            .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: BrandedColor.backgroundGradientColors, startPoint: .topLeading, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
