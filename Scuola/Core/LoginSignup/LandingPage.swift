//
//  LandingPage.swift
//  Scuola
//
//  Created by Braden Ross on 1/29/24.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        NavigationView(){
            VStack {
                Spacer()
                Image("ScuolaLogoMock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)
                    .padding(.top, 50)
                Text("Stream Bigger")
                    .font(.subheadline)
                Spacer()
                VStack {
                    ScuolaNavButton(title: "Log In", navigateTo: LoginScreen())
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
