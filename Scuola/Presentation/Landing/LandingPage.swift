//
//  LandingPage.swift
//  Scuola
//
//  Created by Braden Ross on 1/29/24.
//

import SwiftUI

struct LandingPage: View {
    @ObservedObject var viewModel: AuthViewModel
    var body: some View {
        NavigationView(){
            VStack {
                Spacer()
                Image("FactoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)
                    .padding(.top, 50)
                Text("Stream Bigger")
                    .font(.subheadline)
                Spacer()
                VStack {
                    ScuolaNavButton(title: "Login", navigateTo: LoginPage(viewModel: viewModel))
                    ScuolaNavButton(title: "Sign Up", type: "secondary", navigateTo: SignupScreen())
                        
                }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(colors: BrandedColor.backgroundGradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
