//
//  SignupScreen.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import UserNotifications
import Amplify

struct SignupInfo {
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var birthdate: Date = Date()
    var bio: String = ""
}

struct SignupScreen: View {
    let authenticationUseCase = AuthenticationUseCaseImpl()
    
    @State var screenIndex = 0
    @State var progressIndex = 0
    
    @State var title: String = "Create Your Account"

    @State var signupInfo: SignupInfo = SignupInfo(name: "", username: "" , email: "", password: "", confirmPassword: "", birthdate: Date(), bio: "")
    let picture: String = "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"
    
    var isAnyFieldEmpty: Bool {
        return signupInfo.name.isEmpty || signupInfo.username.isEmpty || signupInfo.email.isEmpty || signupInfo.password.isEmpty || signupInfo.confirmPassword.isEmpty || signupInfo.bio.isEmpty || isUserEighteen(birthdate: signupInfo.birthdate)
    }
    
    func isUserEighteen(birthdate: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        if let userAge = calendar.date(byAdding: .year, value: 18, to: birthdate) {
            return userAge > currentDate
        }
        return false
    }
    
    private var signupScreens: [AnyView] {[
        AnyView(CredentialsInputPage(title: $title, signupInfo: $signupInfo)),
        AnyView(ProfileInfoInputPage(title: $title, signupInfo: $signupInfo)),
        AnyView(BirthdateInputPage(title: $title, signupInfo: $signupInfo)),
        AnyView(TermsAndConditionsPage(title: $title)),
        AnyView(NotificationsPermissionPage(title: $title))
    ]}
    
    @Environment(\.presentationMode) var presentationMode
    
    private func screenIncrement() {
        if(screenIndex < signupScreens.count - 1){
            withAnimation(Animation.linear(duration: 1)){
                progressIndex += 1
            }
            screenIndex += 1
        }
        print(signupInfo)
    }
    
    private func screenDecrement() {
        if(screenIndex > 0){
            if(screenIndex == 1){
                signupInfo.confirmPassword = ""
            }
            withAnimation(Animation.linear(duration: 1)){
                progressIndex -= 1
            }
            screenIndex -= 1
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack(){
            HStack(){
                ProgressView("", value: Double(progressIndex), total: Double(signupScreens.count))
                    .accentColor(.white)
                    .foregroundColor(.white)
            }
            VStack(){
                HStack(){
                    Text(title)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.top, 25)
                Spacer()
                signupScreens[screenIndex]
                Spacer()
                ScuolaButton(title: screenIndex < signupScreens.count - 1 ? "Continue" : "Finish", action: {
                    if screenIndex < signupScreens.count - 1 {
                        screenIncrement()
                    } else {
                        // Call the async function in a background task
                        Task {
                            await authenticationUseCase.submitAccount(isAnyFieldEmpty: isAnyFieldEmpty, signupInfo: signupInfo)
                        }
                    }
                })
                ScuolaButton(title: "Back", type: "secondary", action: {screenDecrement()})
            }
            .padding(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BrandedColor.backgroundGradient)
        .navigationBarBackButtonHidden(true)
    }
}
