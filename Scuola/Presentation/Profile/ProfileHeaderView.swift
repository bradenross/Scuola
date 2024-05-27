//
//  ProfileHeaderView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading){
            VStack(){
                ZStack(){
                    Circle()
                        .stroke(viewModel.user.live ?? false ? BrandedColor.liveGradient : BrandedColor.backgroundGradient, lineWidth: 10)
                        .frame(width: 100, height: 100)
                    Circle()
                        .stroke(BrandedColor.background, lineWidth: 4)
                        .frame(width: 100, height: 100)
                        .overlay(
                            AsyncImage(url: URL(string: viewModel.user.picture ?? "")) { image in
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
                        Text("\(viewModel.user.name)")
                            .bold()
                        if(viewModel.user.verified) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(BrandedColor.backgroundGradient)
                        }
                    }
                    Text("@\(viewModel.user.username)")
                        .foregroundColor(BrandedColor.secondaryText)
                }
                VStack(){
                    Text("\(viewModel.user.bio)")
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
                        Text("\(suffixNumber(num: 0))")
                            .bold()
                        Text("Posts")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Text("\(suffixNumber(num: viewModel.user.following?.count ?? 0))")
                            .bold()
                        Text("Following")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Text("\(suffixNumber(num: viewModel.user.followers?.count ?? 0))")
                            .bold()
                        Text("Followers")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                
                if(viewModel.user.id == UserDefaults.standard.string(forKey: "uid") ?? ""){
                    HStack(){
                        ShareLink(item: URL(string: "https://www.bradenross.me")!) {
                            Text("Share Profile")
                                .bold()
                                .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                                .background(.white)
                                .foregroundColor(BrandedColor.dynamicAccentColor)
                                .cornerRadius(100)
                        }
                        
                        ScuolaCircleNavButton(symbol: "pencil", navigateTo: ProfileEditView(username: viewModel.user.username, name: viewModel.user.name, bio: viewModel.user.bio))
                    }
                } else {
                    HStack(){
                        ScuolaButton(title: "Follow", action: {}, isLoading: false)
                        ScuolaCircleNavButton(symbol: "ellipsis.message", symbolSize: 25, navigateTo: ConversationView())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            
        }
    }
}
