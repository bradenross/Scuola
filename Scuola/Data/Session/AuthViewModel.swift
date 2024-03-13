//
//  AuthViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/3/24.
//

import Foundation
import Amplify
import AWSPluginsCore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var needsConfirmation = false
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    @Published var uniqueIdentifier: String = ""
    
    
    
    init(){
        checkAuthStatus()
    }

    func login(email: String, password: String) async {
        do {
            let result = try await Amplify.Auth.signIn(username: email, password: password)
            switch result.nextStep {
            case .done:
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            case .confirmSignUp:
                DispatchQueue.main.async {
                    self.uniqueIdentifier = email
                    self.needsConfirmation = true
                }
            default:
                print("Sign in requires additional steps: \(result.nextStep)")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                BannerManager.shared.showBanner(title: "Login Failed", message: error.localizedDescription, imageName: "xmark.octagon")
            }
            print("Sign in failed: \(error)")
        }
    }

    func submitAccount(isAnyFieldEmpty: Bool, signupInfo: SignupInfo) async -> String {
        if (!isAnyFieldEmpty) {
            let userAttributes = [
                AuthUserAttribute(.email, value: signupInfo.email),
                AuthUserAttribute(.name, value: signupInfo.name),
                AuthUserAttribute(.givenName, value: signupInfo.name),
                AuthUserAttribute(.familyName, value: signupInfo.name),
                AuthUserAttribute(.preferredUsername, value: signupInfo.username),
                AuthUserAttribute(.birthDate, value: "12/09/1999"),
            ]
            
            do {
                let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
                let signUpResult = try await Amplify.Auth.signUp(username: signupInfo.email, password: signupInfo.password, options: options)
                print("Sign up successful: \(signUpResult.nextStep)")

                // Using signUpResult to attempt to get the user ID directly
                // Note: This approach depends on the specifics of the signUpResult's contents, which might vary
                if let userID = signUpResult.userID {
                    let user = User(id: userID, // Use the userID directly from the signUpResult
                                    name: signupInfo.name,
                                    bio: signupInfo.bio,
                                    live: false,
                                    picture: "https://example.com/default-avatar.jpg",
                                    userType: "default",
                                    username: signupInfo.username,
                                    verified: false)
                    
                    let dataResult = try await Amplify.API.mutate(request: .create(user))
                    switch dataResult {
                    case .success(let userRecord):
                        print("Successfully created user record: \(userRecord)")
                        self.uniqueIdentifier = signupInfo.email
                        self.needsConfirmation = true
                        return ""
                    case .failure(let error):
                        print("Got failed result with \(error.errorDescription)")
                        return "Failure: \(error.errorDescription)"
                    }
                } else {
                    print("User ID not found in signUpResult")
                    return "User ID not found"
                }
            } catch {
                print("Operation failed with error: \(error)")
                return "Operation failed: \(error)"
            }
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
                self.needsConfirmation = false
            default:
                print("Confirmation step not completed. Next step: \(result.nextStep)")
                // Handle other cases, if necessary (e.g., require additional information)
            }
        } catch {
            print("Failed to confirm sign up: \(error)")
            throw error // Rethrow or handle error as needed
        }
    }

    func resendConfirmationCode(to email: String) async -> Result<Void, AuthError> {
        do {
            let result = try await Amplify.Auth.resendSignUpCode(for: email)
            return .success(())
        } catch let error as AuthError {
            print("Failed to resend confirmation code: \(error)")
            return .failure(error)
        } catch {
            // This shouldn't happen, but catch any other unexpected errors
            print("Unexpected error: \(error)")
            return .failure(AuthError.unknown("Unexpected error occurred", error))
        }
    }

    
    func signOut() async {
        do {
            try await Amplify.Auth.signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    func checkAuthStatus() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                self.isAuthenticated = session.isSignedIn
                try await Task.sleep(nanoseconds: 1_000_000_000)
                self.isLoading = false
            } catch {
                print("Error checking Amplify auth session: \(error)")
                try await Task.sleep(nanoseconds: 1_000_000_000)
                self.isLoading = false
            }
        }
    }

    
    
    
    func getUser(byId userId: String) async {
        do {
            let result = try await Amplify.API.query(
                request: .get(User.self, byId: userId)
            )
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Could not find model")
                    return
                }
                print("Successfully retrieved model: \(model)")
            case .failure(let error):
                print("Got failed result with \(error)")
            }
        } catch let error as APIError {
            print("Failed to query user - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

}
