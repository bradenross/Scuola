//
//  ProfileView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI

struct ProfileView: View {
    let accNum = "ASRrVxJhi8e9l0NSNGCZqdPhsu62"
    @State var acc: Account = Account(id: "", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "user", verified: false, live: false)
    var body: some View {
        ScrollView(){
            VStack(){
                ProfileHeaderView(account: $acc)
            }
        }
        .onAppear(){
            getAccountFromFB(id: accNum) { account in
                if let account = account {
                    // Do something with the retrieved account
                    print("Retrieved account: \(account)")
                    acc = account
                } else {
                    print("Account not found or error occurred")
                }
            }
        }
    }
}
