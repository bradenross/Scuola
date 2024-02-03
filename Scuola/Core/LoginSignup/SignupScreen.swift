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
        return signupInfo.name.isEmpty || signupInfo.username.isEmpty || signupInfo.email.isEmpty || signupInfo.password.isEmpty || signupInfo.confirmPassword.isEmpty || signupInfo.bio.isEmpty || isUnderAge
    }
    
    var isUnderAge: Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        if let birthdate = calendar.date(byAdding: .year, value: 18, to: signupInfo.birthdate) {
            return birthdate > currentDate
        }
        return false
    }
    
    private var signupScreens: [AnyView] {[
        AnyView(EmailPasswordPage(title: $title, signupInfo: $signupInfo)),
        AnyView(ProfileInfoPage(title: $title, signupInfo: $signupInfo)),
        AnyView(BirthdatePage(title: $title, signupInfo: $signupInfo)),
        AnyView(TermsAndConditionsPage(title: $title))
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

struct EmailPasswordPage: View {
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

struct ProfileInfoPage: View {
    @Binding var title: String
    @Binding var signupInfo: SignupInfo
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "person.crop.rectangle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Username", text: $signupInfo.username)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Name", text: $signupInfo.name)
                        .textInputAutocapitalization(.words)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Bio", text: $signupInfo.bio,  axis: .vertical)
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

struct ExampleProfilePage: View {
    @State var acc: Account = Account(id: "", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "default", verified: false, live: false, picture: "")
    var body: some View {
        VStack(){
            GeometryReader { geometry in
                ScrollView(){
                    VStack(){
                        ProfileHeaderView(account: $acc)
                        ProfileContentView(account: $acc)
                            .frame(maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity)
                }
            }
        }
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

struct TermsAndConditionsPage: View {
    @Binding var title: String
    var body: some View {
        VStack(){
            ScrollView(){
                Text("Sample Privacy Policy\nIntroduction\nThis Privacy Policy outlines the types of personal information that [Your Company Name] (\"we,\" \"us,\" or \"our\") may collect, how we use it, and the choices you have regarding your information. Please read this policy carefully.\nInformation We Collect\nPersonal Information: We may collect personally identifiable information, such as your name, email address, and other contact details, when you voluntarily provide it to us.\nUsage Data: We may collect information about how you interact with our website or application, such as your IP address, browser type, and device information.\nHow We Use Your Information\nProviding Services: We use your information to provide and improve our services, respond to your inquiries, and personalize your experience.\nAnalytics: We may use analytics tools to analyze user behavior and improve our services.\nMarketing: With your consent, we may send you promotional materials or information about our products and services.\nSharing Your Information\nThird-Party Service Providers: We may share your information with third-party service providers who help us deliver our services.\nLegal Compliance: We may disclose your information if required by law or in response to a valid legal request.\nYour Choices\nOpt-Out: You can opt-out of receiving promotional communications from us by following the instructions provided in the communication.\nAccess and Correction: You have the right to access and correct your personal information. Contact us for assistance.\nSecurity\nWe take reasonable measures to protect your information from unauthorized access or disclosure.\nChildren's Privacy\nOur services are not intended for individuals under the age of 13. We do not knowingly collect personal information from children.\nChanges to This Policy\nWe may update this Privacy Policy periodically. Please review this policy regularly for any changes.\nContact Us\nIf you have any questions or concerns about this Privacy Policy, please contact us at [your contact email].\nDate of Last Update: [Insert Date]")
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity)
            
            Text("By pressing 'Finish' you accept to our terms and conditions and privacy policy.")
                .font(.footnote)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
        }
        .onAppear{
            title = "Terms and Conditions"
        }
    }
}
