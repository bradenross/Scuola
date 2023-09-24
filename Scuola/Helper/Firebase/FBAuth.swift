//
//  FBAuth.swift
//  Scuola
//
//  Created by Braden Ross on 7/9/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FBAuth {
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                UserDefaults.standard.set(uid, forKey: "uid")
            }
        }
    }
    
    func createNewUser(user: Account){
        let db = Firestore.firestore()
            
            do {
                let data = try JSONEncoder().encode(user)
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                
                db.collection("customObjects").document(user.id).setData(dictionary) { error in
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
    
}
