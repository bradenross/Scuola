//
//  ProfileBarView.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ProfileBarView: View {
    @Binding var isFollowing: Bool
    @Binding var accountData: Account
    
    let interactionUseCase = UserInteractionUseCaseImpl()
    let videoDataUseCase = FetchVideoDataUseCaseImpl()
    
    private func onFollowTapped(){
        if(isFollowing){
            interactionUseCase.userUnsubscribeToUser(userID: accountData.id)
        } else {
            interactionUseCase.userSubscribeToUser(userID: accountData.id)
        }
        isFollowing.toggle()
    }
    
    var body: some View {
        HStack(){
            Button(action: {}){
                NavigationLink(destination: ProfileView(accId: accountData.id)){
                    Circle()
                        .stroke(BrandedColor.background, lineWidth: 4)
                        .frame(width: 50, height: 50)
                        .overlay(
                            AsyncImage(url: URL(string: accountData.picture)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                
                            }
                        )
                    VStack(alignment: .leading){
                        Text(accountData.name)
                            .foregroundColor(BrandedColor.text)
                        Text("\(suffixNumber(num: accountData.followers)) Followers")
                            .foregroundColor(BrandedColor.secondaryText)
                    }
                }
            }
            Spacer()
                .frame(maxWidth: .infinity)
                .layoutPriority(-1)
            ScuolaActionButton(title: isFollowing ? "Following" : "Follow", symbol: isFollowing ? "heart.fill" : "heart", symbolColor: isFollowing ? .red : BrandedColor.dynamicAccentColor, action: {
                onFollowTapped()
            })
        }
        .padding(.horizontal, 20)
    }
}
