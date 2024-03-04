//
//  AuthViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/3/24.
//

import Foundation
import Amplify

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var needsConfirmation = false
    @Published var errorMessage: String?
    
    @Published var uniqueIdentifier: String = ""

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
            }
            print("Sign in failed: \(error)")
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
}
