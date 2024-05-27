//
//  ProfileViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/25/24.
//

import Foundation
import Amplify

class ProfileViewModel: ObservableObject {
    @Published var userID: String
    @Published var user: User = User(name: "", bio: "", birthdate: Temporal.DateTime.now(), userType: "default", username: "", verified: false)
    @Published var loading = false
    
    init(userID: String) {
        self.userID = userID
        Task {
            await getUser(byId: userID)
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
                DispatchQueue.main.async {
                    self.user = model
                    print("Successfully retrieved and updated model: \(model)")
                }
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
