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
    @State var isHeaderLoading: Bool = true
    
    private func loadData(){
        getAccountFromFB(id: accId) { account in
            if let account = account {
                print("Retrieved account: \(account)")
                acc = account
                isHeaderLoading = false
            } else {
                print("Account not found or error occurred")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(){
                VStack(){
                    ProfileHeaderView(account: $acc, isLoading: $isHeaderLoading)
                    ProfileContentView(account: $acc)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .refreshable {
//                try? await Task.sleep(nanoseconds: 1_000_000_000)
//                loadData()
//            }
        }
        .toolbar(.hidden)
        .onAppear(){
            loadData()
        }
    }
}
