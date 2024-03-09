//
//  VerifyPage.swift
//  Scuola
//
//  Created by Braden Ross on 3/3/24.
//

import SwiftUI

struct VerifyPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var bannerManager: BannerManager
    
    @State var codeInput: String = ""
    
    @State private var countdown = 60
    @State private var isCountdownActive = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private var resendEmailButtonText: String {
        if isCountdownActive {
            return "Resend in \(countdown) seconds"
        } else {
            return "Resend Verification Email"
        }
    }
    
    func startCountdown() {
        if !isCountdownActive {
            // Reset the countdown and activate it
            countdown = 60
            isCountdownActive = true
            
            // Use a Timer to decrement the countdown each second
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    // Stop the timer and reset the countdown state when it reaches 0
                    timer.invalidate()
                    self.isCountdownActive = false
                }
            }
            
            Task {
                let result = await authViewModel.resendConfirmationCode(to: authViewModel.uniqueIdentifier)
                switch result {
                case .success():
                    // Update UI to inform the user that the code was resent
                    print("Confirmation code was resent successfully.")
                case .failure(let error):
                    // Handle error, update UI accordingly
                    print("Failed to resend confirmation code: \(error.localizedDescription)")
                    bannerManager.showBanner(title: "Error Signing Up", message: "\(error.localizedDescription)", imageName: "star")
                }
            }
        }
    }
    
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
            ScuolaButton(title: resendEmailButtonText, type: "tertiary"){
                
            }
            .padding(.vertical, 15)
            .disabled(isCountdownActive)
            Spacer()
            VStack {
                
                ScuolaButton(title: "Confirm", action: {
                    Task {
                        try await authViewModel.confirmSignUp(for: authViewModel.uniqueIdentifier, with: codeInput)
                    }
                })
                
                ScuolaButton(title: "Close", type: "secondary"){
                    authViewModel.needsConfirmation = false
                }
                    
            }
            .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: BrandedColor.backgroundGradientColors, startPoint: .topLeading, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear(){
            startCountdown()
        }
    }
}
