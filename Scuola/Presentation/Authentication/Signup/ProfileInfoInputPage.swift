//
//  ProfileInfoInputPage.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import SwiftUI

struct ProfileInfoInputPage: View {
    @Binding var title: String
    @Binding var signupInfo: SignupInfo
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "person.crop.rectangle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Username", text: $signupInfo.username)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Name", text: $signupInfo.name)
                        .textInputAutocapitalization(.words)
                        .foregroundStyle(.white)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
            
            HStack(){
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
                VStack(){
                    TextField("Bio", text: $signupInfo.bio,  axis: .vertical)
                        .lineLimit(1...10)
                    Divider()
                        .overlay(.white)
                }
            }
            .padding(.vertical, 10)
        }
        .onAppear{
            title = "Customize Your Profile"
        }
    }
}
