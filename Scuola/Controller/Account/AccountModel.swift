//
//  AccountModel.swift
//  Scuola
//
//  Created by Braden Ross on 8/13/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Account: Identifiable, Codable {
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
                   let live = accountData["live"] as? Bool {
                        let birthdateDate = birthdate.dateValue()
                    
                        let account = Account(id: id, username: username, name: name, bio: bio, followers: followers, following: following, birthdate: birthdateDate, userType: userType, verified: verified, live: live)
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

func suffixNumber(num: Int) -> String{
    if(num < 1000){
        return "\(num)"
    }
    
    let exp:Int = Int(log10(Double(num)) / 3.0 ); //log10(1000));

    let units:[String] = ["K","M","G","T","P","E"];

    let roundedNum:Double = round(Double(10 * num) / pow(1000.0,Double(exp))) / 10;

    return "\(roundedNum)\(units[exp-1])";

}
