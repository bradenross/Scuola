//
//  ProfileHeaderView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var account: Account
    var body: some View {
        VStack(alignment: .leading){
            VStack(){
                HStack(){
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(suffixNumber(num: account.following))")
                            .bold()
                        Text("Following")
                    }
                    Spacer()
                    ZStack(){
                        Circle()
                            .stroke(BrandedColor.backgroundGradient, lineWidth: 8)
                            .frame(width: 100, height: 100)
                        Circle()
                            .stroke(Color.black, lineWidth: 4)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image("headerpic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            )
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(suffixNumber(num: account.followers))")
                            .bold()
                        Text("Followers")
                    }
                    Spacer()
                }
                VStack(){
                    HStack(){
                        Text("\(account.name)")
                            .bold()
                        if(account.verified) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(BrandedColor.backgroundGradient)
                        }
                    }
                    Text("@\(account.username)")
                        .foregroundColor(BrandedColor.secondaryText)
                }
                Text("\(account.bio)")
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
                
                ScuolaButton(title: "edit", type: "secondary", action: {})
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            
        }
    }
}
