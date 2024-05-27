//
//  ProfileContentView.swift
//  Scuola
//
//  Created by Braden Ross on 10/3/23.
//

import SwiftUI

struct ProfileContentView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(alignment: .top){
                VideoPostsView(account: $viewModel.user)
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
