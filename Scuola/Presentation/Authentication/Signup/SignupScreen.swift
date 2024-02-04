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
    
    private func submitAccount(){
        if(!isAnyFieldEmpty){
            Auth.auth().createUser(withEmail: signupInfo.email, password: signupInfo.password) { authResult, error in
                if let error = error {
                    print("Error signing up: \(error.localizedDescription)")
                } else {
                    print("User signed up successfully")
                    let uid = authResult!.user.uid
                    let account = Account(id: uid, username: signupInfo.username, name: signupInfo.name, bio: signupInfo.bio, followers: 0, following: 0, birthdate: signupInfo.birthdate, userType: "default", verified: false, live: false, picture: picture)
                    do {
                        UserDefaults.standard.set(uid, forKey: "uid")
                        UserDefaults.standard.set(signupInfo.username, forKey: "username")
                        let db = Firestore.firestore()
                        try db.collection("users").document(account.id).setData(from: account)
                        screenIncrement()
                    } catch let error {
                        print("Error encoding or storing data: \(error)")
                    }
                }
            }
        } else {
            print("MISSING INFO OR UNDERAGE")
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
                    screenIndex < signupScreens.count - 1 ? screenIncrement() : submitAccount()
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

#Preview {
    SignupScreen()
}
