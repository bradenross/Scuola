//
//  AuthenticationUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Amplify

protocol AuthenticationUseCase {
    func login(email: String, password: String) async
    func signOut()
    func createNewUser(user: Account)
    func submitAccount(isAnyFieldEmpty: Bool, signupInfo: SignupInfo) async
    func confirmSignUp(for username: String, with confirmationCode: String) async throws
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    func signOut(){
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }
    }
    
    func login(email: String, password: String) async {
        print("LOGGING IN")
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            print("LOGGING IN PART 2")
            if signInResult.isSignedIn {
                print("Sign In Succeeded")
            } else {
                print("Sign in unsuccessful: \(signInResult.nextStep)")
            }
        } catch {
            print("Error: \(error)")
        }
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if error != nil {
//                print("BRADEN ROSS")
//                print(error?.localizedDescription ?? "")
//            } else {
//                guard let uid = Auth.auth().currentUser?.uid else { return }
//                UserDefaults.standard.set(uid, forKey: "uid")
//            }
//        }
    }
    
    func createNewUser(user: Account){
        let db = Firestore.firestore()
            
            do {
                let data = try JSONEncoder().encode(user)
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                
                db.collection("users").document(user.id).setData(dictionary) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            } catch {
                print("Encoding error: \(error)")
            }
    }
    
    func submitAccount(isAnyFieldEmpty: Bool, signupInfo: SignupInfo) async{
        if(!isAnyFieldEmpty){
            let userAttributes = [AuthUserAttribute(.email, value: signupInfo.email), AuthUserAttribute(.name, value: signupInfo.name), AuthUserAttribute(.givenName, value: signupInfo.name), AuthUserAttribute(.familyName, value: signupInfo.name), AuthUserAttribute(.preferredUsername, value: signupInfo.username), AuthUserAttribute(.birthDate, value: "12/09/1999"),]
                    
            do {
                let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
                let result = try await Amplify.Auth.signUp(username: signupInfo.email, password: signupInfo.password, options: options)
                print("Sign up successful: \(result.nextStep)")
                // Update UI to reflect success, e.g., navigate to a new screen or show a success message
            } catch {
                print("Sign up failed with error: \(error)")
                // Update UI to reflect the error, e.g., show an alert with the error message
                // Example: showErrorAlert = true
            }
//            Auth.auth().createUser(withEmail: signupInfo.email, password: signupInfo.password) { authResult, error in
//                if let error = error {
//                    print("Error signing up: \(error.localizedDescription)")
//                } else {
//                    print("User signed up successfully")
//                    let uid = authResult!.user.uid
//                    let account = Account(id: uid, username: signupInfo.username, name: signupInfo.name, bio: signupInfo.bio, followers: 0, following: 0, birthdate: signupInfo.birthdate, userType: "default", verified: false, live: false, picture: picture)
//                    do {
//                        UserDefaults.standard.set(uid, forKey: "uid")
//                        UserDefaults.standard.set(signupInfo.username, forKey: "username")
//                        let db = Firestore.firestore()
//                        try db.collection("users").document(account.id).setData(from: account)
//                        screenIncrement()
//                    } catch let error {
//                        print("Error encoding or storing data: \(error)")
//                    }
//                }
//            }
        } else {
            print("Missing information or underage")
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) async throws {
        do {
            let result = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
            switch result.nextStep {
            case .done:
                print("User confirmed successfully")
                // Proceed with user login or next steps in your app
            default:
                print("Confirmation step not completed. Next step: \(result.nextStep)")
                // Handle other cases, if necessary (e.g., require additional information)
            }
        } catch {
            print("Failed to confirm sign up: \(error)")
            throw error // Rethrow or handle error as needed
        }
    }
    
}
