//
//  ProfileContentView.swift
//  Scuola
//
//  Created by Braden Ross on 10/3/23.
//

import SwiftUI

struct ProfileContentView: View {
    @Binding var account: Account
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(alignment: .top){
                VideoPostsView(account: $account)
                    .containerRelativeFrame(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                SignupScreen()
                    .containerRelativeFrame(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                SignupScreen()
                    .containerRelativeFrame(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}
