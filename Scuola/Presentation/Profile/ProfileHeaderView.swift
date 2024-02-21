//
//  ProfileHeaderView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var account: Account
    @Binding var isLoading: Bool
    var body: some View {
        VStack(alignment: .leading){
            VStack(){
                ZStack(){
                    Circle()
                        .stroke(account.live ? BrandedColor.liveGradient : BrandedColor.backgroundGradient, lineWidth: 8)
                        .frame(width: 100, height: 100)
                    Circle()
                        .stroke(BrandedColor.background, lineWidth: 4)
                        .frame(width: 100, height: 100)
                        .overlay(
                            AsyncImage(url: URL(string: account.picture)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                
                            }
                        )
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
                VStack(){
                    Text("\(account.bio)")
                        .font(.callout)
                        .lineLimit(5)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                    Text(.init("[bradenross.me](https://www.bradenross.me)"))
                        .foregroundStyle(BrandedColor.dynamicAccentColor)
                        .font(.callout)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 10)
                HStack(spacing: 0) {
                    Spacer()
                    
                    VStack {
                        Text("\(suffixNumber(num: account.following))")
                            .bold()
                        Text("Posts")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Text("\(suffixNumber(num: account.following))")
                            .bold()
                        Text("Following")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Text("\(suffixNumber(num: account.followers))")
                            .bold()
                        Text("Followers")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                
                if(account.id == UserDefaults.standard.string(forKey: "uid")!){
                    HStack(){
                        ScuolaNavButton(title: "Share Profile", navigateTo: SignupScreen())
                        ScuolaCircleNavButton(symbol: "pencil", navigateTo: ProfileEditView(username: account.username, name: account.name, bio: account.bio))
                    }
                } else {
                    HStack(){
                        ScuolaButton(title: "Follow", action: {}, isLoading: isLoading)
                        ScuolaCircleNavButton(symbol: "ellipsis.message", symbolSize: 25, navigateTo: SignupScreen())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            
        }
    }
}
