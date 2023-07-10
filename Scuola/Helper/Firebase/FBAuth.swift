//
//  FBAuth.swift
//  Scuola
//
//  Created by Braden Ross on 7/9/23.
//

import Foundation
import Firebase

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
                print("success")
            }
        }
    }
    
    
    
}
