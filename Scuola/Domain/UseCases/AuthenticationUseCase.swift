//
//  AuthenticationUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import Foundation
import Amplify

protocol AuthenticationUseCase {
    func login(email: String, password: String) async
    func signOut() async
    func submitAccount(isAnyFieldEmpty: Bool, signupInfo: SignupInfo) async -> String
    func confirmSignUp(for username: String, with confirmationCode: String) async throws
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    func signOut() async{
        await Amplify.Auth.signOut()
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
    }
    
    func submitAccount(isAnyFieldEmpty: Bool, signupInfo: SignupInfo) async -> String{
        if(!isAnyFieldEmpty){
            let userAttributes = [AuthUserAttribute(.email, value: signupInfo.email), AuthUserAttribute(.name, value: signupInfo.name), AuthUserAttribute(.givenName, value: signupInfo.name), AuthUserAttribute(.familyName, value: signupInfo.name), AuthUserAttribute(.preferredUsername, value: signupInfo.username), AuthUserAttribute(.birthDate, value: "12/09/1999"),]
                    
            do {
                let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
                let result = try await Amplify.Auth.signUp(username: signupInfo.email, password: signupInfo.password, options: options)
                print("Sign up successful: \(result.nextStep)")
                return ""
            } catch {
                print("Sign up failed with error: \(error)")
                return "\(error)"
            }
            //MAKE SURE TO ADD IN USER INFORMATION HERE
        } else {
            print("Missing information or underage")
            return "Missing Information or Underage User"
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
