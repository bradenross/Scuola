//
//  SignupScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import UserNotifications

struct SignupScreen: View {
    @State var screenIndex = 0
    @State var progressIndex = 0
    
    @State var title: String = "Create Your Account"
    
    @State var name: String = ""
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var birthdate: Date = Date()
    @State var bio: String = ""
    let picture: String = "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"
    
    private var signupScreens: [AnyView] {[
        AnyView(EmailPasswordPage(title: $title, email: $email, password: $password, confirmPassword: $confirmPassword)),
        AnyView(ProfileInfoPage(title: $title, name: $name, username: $username, bio: $bio)),
        AnyView(BirthdatePage(title: $title, birthdate: $birthdate))
    ]}
    
    @Environment(\.presentationMode) var presentationMode
    
    private func screenIncrement() {
        if(screenIndex < signupScreens.count - 1){
            withAnimation(Animation.linear(duration: 1)){
                progressIndex += 1
            }
            screenIndex += 1
        }
    }
    
    private func screenDecrement() {
        if(screenIndex > 0){
            withAnimation(Animation.linear(duration: 1)){
                progressIndex -= 1
            }
            screenIndex -= 1
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func submitAccount(){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("User signed up successfully")
                let uid = authResult!.user.uid
                let account = Account(id: uid, username: username, name: name, bio: bio, followers: 0, following: 0, birthdate: birthdate, userType: "default", verified: false, live: false, picture: picture)
                do {
                    UserDefaults.standard.set(uid, forKey: "uid")
                    UserDefaults.standard.set(username, forKey: "username")
                    let db = Firestore.firestore()
                    try db.collection("users").document(account.id).setData(from: account)
                    screenIncrement()
                } catch let error {
                    print("Error encoding or storing data: \(error)")
                }
            }
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

struct EmailPasswordPage: View {
    @Binding var title: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "envelope.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Email", text: $email)
                        .keyboardType(UIKeyboardType.emailAddress)
                        .foregroundColor(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "lock.open.fill")
                    .foregroundColor(.white)
                VStack(){
                    SecureField("Password", text: $password)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                VStack(){
                    SecureField("Confirm Password", text: $confirmPassword)
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

struct ProfileInfoPage: View {
    @Binding var title: String
    @Binding var name: String
    @Binding var username: String
    @Binding var bio: String
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "person.crop.rectangle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Username", text: $username)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Name", text: $name)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Bio", text: $bio,  axis: .vertical)
                        .lineLimit(1...10)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
        }
        .onAppear{
            title = "Customize Your Profile"
        }
    }
}

struct BirthdatePage: View {
    @Binding var title: String
    @Binding var birthdate: Date

    var body: some View {
        VStack(){
            DatePicker("Birthdate", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
        .onAppear{
            title = "When Were You Born?"
        }
        .padding(15)
    }
}

struct NotificationsPermissionPage: View {
    @Binding var title: String
    
    var body: some View {
        HStack(){
            Spacer()
            VStack(){
                Text("Why turn on notifications?")
                    .font(.headline)
                    .bold()
                TabView(){
                    Text("🔔 Creators go live")
                    Text("💬 Messages from your friends instantly")
                    Text("📨 Interactions on your posts")
                }.tabViewStyle(PageTabViewStyle())
            }
            .frame(height: 200)
            .background(){
                BrandedColor.color1
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            Spacer()
        }
        .padding(15)
        .onAppear{
            requestNotificationPermission()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Push notification permission granted")
                // You can handle the scenario when permission is granted
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
                // Handle the error case
            }
        }
    }
}
