//
//  EditAccountUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/19/24.
//

import Amplify
import AWSAPIPlugin
import Foundation

protocol EditAccountUseCase {
    func updateAccount(uid: String, newAccountInfo: User) async
}

final class EditAccountUseCaseImpl: EditAccountUseCase {
    func updateAccount(uid: String, newAccountInfo: User) async {
        let mutationDocument = """
        mutation UpdateUser($input: UpdateUserInput!) {
          updateUser(input: $input) {
            id
            name
            username
            bio
            picture
          }
        }
        """

        let variables = [
            "input": [
                "id": uid,
                "name": newAccountInfo.name,
                "username": newAccountInfo.username,
                "bio": newAccountInfo.bio,
                "picture": newAccountInfo.picture
            ]
        ]

        do {
            // Specify the responseType explicitly to help with type inference
            let request = GraphQLRequest<JSONValue>(document: mutationDocument, variables: variables, responseType: JSONValue.self)
            let result = try await Amplify.API.mutate(request: request)
            
            switch result {
            case .success(let data):
                print("User updated successfully: \(data)")
            case .failure(let apiError):
                print("Failed to update user: \(apiError)")
            }
        } catch {
            print("Error performing mutation: \(error)")
        }
    }
    
    func createUser(updatedUser: User) async {
        
        do {
            let result = try await Amplify.API.mutate(request: .create(updatedUser))
            switch result {
            case .success(let todo):
                print("Successfully created todo: \(todo)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
