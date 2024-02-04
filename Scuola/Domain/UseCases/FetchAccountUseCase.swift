//
//  FetchAccountUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

func getAccountFromFB(id: String, completion: @escaping (Account?) -> Void) {
    AppState.shared.isLoading = true
    
    let db = Firestore.firestore()
    let documentRef = db.collection("users").document(id)
    
    documentRef.getDocument { document, error in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(nil)
        } else {
            if let document = document, document.exists {
                if let accountData = document.data(),
                   let id = accountData["id"] as? String,
                   let username = accountData["username"] as? String,
                   let name = accountData["name"] as? String,
                   let bio = accountData["bio"] as? String,
                   let followers = accountData["followers"] as? Int,
                   let following = accountData["following"] as? Int,
                   let birthdate = accountData["birthdate"] as? Timestamp,
                   let userType = accountData["userType"] as? String,
                   let verified = accountData["verified"] as? Bool,
                   let live = accountData["live"] as? Bool,
                   let picture = accountData["picture"] as? String {
                        let birthdateDate = birthdate.dateValue()
                    
                        let account = Account(id: id, username: username, name: name, bio: bio, followers: followers, following: following, birthdate: birthdateDate, userType: userType, verified: verified, live: live, picture: picture)
                        AppState.shared.isLoading = false
                        completion(account)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
