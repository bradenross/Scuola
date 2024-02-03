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
        TabView {
            LoginScreen()
            SignupScreen()
            LoginScreen()
            SignupScreen()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
