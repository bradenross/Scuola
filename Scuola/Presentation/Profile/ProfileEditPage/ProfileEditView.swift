//
//  ProfileEditView.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct ProfileEditView: View {
    @State var username: String
    @State var name: String
    @State var bio: String
    var body: some View {
        VStack(){
            Circle()
                .stroke(BrandedColor.background, lineWidth: 4)
                .frame(width: 100, height: 100)
                .overlay(
                    AsyncImage(url: URL(string: "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } placeholder: {
                        
                    }
                )
            Divider()
            HStack(){
                Text("Name")
                Spacer()
                    .frame(width: 25)
                Text(name)
            }
            Divider()
            HStack(){
                Text("Username")
                Spacer()
                    .frame(width: 25)
                Text(username)
            }
            Divider()
            HStack(){
                Text("Bio")
                Spacer()
                    .frame(width: 25)
                Text(bio)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
}
