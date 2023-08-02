//
//  SignupScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI

struct SignupScreen: View {
    @State var screenIndex = 0
    @State var firstName: String = ""
    private var signupScreens: [AnyView] {[
        AnyView(LoginScreen()),
        AnyView(PersonalInfoPage(firstName: $firstName)),
        AnyView(LoginScreen()),
        AnyView(PersonalInfoPage(firstName: $firstName))
    ]}
    
    @Environment(\.presentationMode) var presentationMode
    
    private func screenIncrement() {
        if(screenIndex < signupScreens.count - 1){
            screenIndex += 1
        }
    }
    
    private func screenDecrement() {
        if(screenIndex > 0){
            screenIndex -= 1
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack(){
            HStack(){
                ProgressView("\(screenIndex)/\(signupScreens.count)", value: Double(screenIndex), total: Double(signupScreens.count))
                    .accentColor(.white)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
            Spacer()
            signupScreens[screenIndex]
            Spacer()
            Button(action: {screenIncrement()}) {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: 300, maxHeight: 50)
                    .background(.white)
                    .foregroundColor(ScuolaColor.color1)
                    .cornerRadius(100)
            }
            Button(action: {screenDecrement()}) {
                Text("Back")
                    .bold()
                    .frame(maxWidth: 300, maxHeight: 50)
                    .background(.white)
                    .foregroundColor(ScuolaColor.color1)
                    .cornerRadius(100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ScuolaColor.backgroundGradient)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen()
    }
}
