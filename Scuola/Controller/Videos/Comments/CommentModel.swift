//
//  CommentModel.swift
//  Scuola
//
//  Created by Braden Ross on 8/20/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommentModel: Identifiable, Codable {
    var id: String
    var username: String
    var name: String
    var bio: String
    var followers: Int
    var following: Int
    var birthdate: Date
    var userType: String
    var verified: Bool
    var live: Bool
}

func getComment(videoID: String, id: String, completion: @escaping (Account?) -> Void) {
    AppState.shared.isLoading = true
    
    let db = Firestore.firestore()
    let documentRef = db.collection("comments").document(videoID).collection("comments").document(id)
    
    documentRef.getDocument { document, error in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(nil)
        } else {
            if let document = document, document.exists {
                let test = document.data()
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

func getAllComments(videoID: String, completion: @escaping (Account?) -> Void) {
    AppState.shared.isLoading = true
    
    let db = Firestore.firestore()
    let documentRef = db.collection("comments").document(videoID).collection("comments")
    
    documentRef.getDocuments { snapshot, error in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(nil)
        } else {
            snapshot?.documents.forEach({ (documentSnapshot) in
                  let documentData = documentSnapshot.data()
                  let comment = documentData["comment"] as? String
                  let user = documentData["user"] as? String
                  print("comment: \(comment ?? "(unknown)")")
                  print("user: \(user ?? "(unknown)")")
                })
            AppState.shared.isLoading = false
        }
    }
}
