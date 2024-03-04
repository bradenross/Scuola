//
//  VerifyPage.swift
//  Scuola
//
//  Created by Braden Ross on 3/3/24.
//

import SwiftUI

struct VerifyPage: View {
    @ObservedObject var viewModel: AuthViewModel
    
    let authenticationUseCase = AuthenticationUseCaseImpl()
    
    @State var codeInput: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack(){
                Text("Confirmation Code")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            .padding(.horizontal, 25)
            Spacer()
            HStack(){
                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Code", text: $codeInput)
                        .keyboardType(UIKeyboardType.phonePad)
                        .foregroundColor(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.horizontal, 25)
            Spacer()
            VStack {
                
                ScuolaButton(title: "Confirm", action: {
                    Task {
                        try await viewModel.confirmSignUp(for: viewModel.uniqueIdentifier, with: codeInput)
                    }
                })
                    
            }
            .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: BrandedColor.backgroundGradientColors, startPoint: .topLeading, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
