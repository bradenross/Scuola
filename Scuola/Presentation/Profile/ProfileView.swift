//
//  ProfileView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI

struct ProfileView: View {
    var accId: String
    @State var acc: Account = Account(id: "", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "default", verified: false, live: false, picture: "")
    var body: some View {
        GeometryReader { geometry in
            ScrollView(){
                VStack(){
                    ProfileHeaderView(account: $acc)
                    ProfileContentView(account: $acc)
                        .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
        .onAppear(){
            getAccountFromFB(id: accId) { account in
                if let account = account {
                    print("Retrieved account: \(account)")
                    acc = account
                } else {
                    print("Account not found or error occurred")
                }
            }
        }
    }
}
