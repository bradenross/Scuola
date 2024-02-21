//
//  EditAccountUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/19/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol EditAccountUseCase {
    func updateAccount(uid: String, newAccountInfo: Account)
}

final class EditAccountUseCaseImpl: EditAccountUseCase {
    let db = Firestore.firestore()
    
    func updateAccount(uid: String, newAccountInfo: Account) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        
        let newData = [
            "name": newAccountInfo.name,
            "username": newAccountInfo.username,
            "bio": newAccountInfo.bio,
            "picture": newAccountInfo.picture
        ]
        
        if(uid == userID){
            let userRef = db.collection("users").document(uid)
            
            userRef.updateData(newData) { error in
                if let error = error {
                    print("Error updating user data: \(error)")
                } else {
                    print("User updated successfully!")
                }
                
            }
        } else {
            print("Not current user")
        }
    }
}
