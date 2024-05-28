//
//  ProfileBarView.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ProfileBarView: View {
    @ObservedObject var viewModel: VideoAssetViewModel
    
    let interactionUseCase = UserInteractionUseCaseImpl()
    let videoDataUseCase = FetchVideoDataUseCaseImpl()
    
    private func onFollowTapped(){
        if(viewModel.isFollowing){
            interactionUseCase.userUnsubscribeToUser(userID: viewModel.videoInfo.userID)
        } else {
            interactionUseCase.userSubscribeToUser(userID: viewModel.videoInfo.userID)
        }
        viewModel.isFollowing.toggle()
    }
    
    var body: some View {
        HStack(){
            Button(action: {}){
                NavigationLink(destination: ProfileView(accID: viewModel.videoInfo.userID)){
                    Circle()
                        .stroke(BrandedColor.background, lineWidth: 4)
                        .frame(width: 50, height: 50)
                        .overlay(
                            AsyncImage(url: URL(string: viewModel.ownerAccountData.picture ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                
                            }
                        )
                    VStack(alignment: .leading){
                        Text(viewModel.ownerAccountData.name)
                            .foregroundColor(BrandedColor.text)
                        Text("\(suffixNumber(num: viewModel.ownerAccountData.followers?.count ?? 0)) Followers")
                            .foregroundColor(BrandedColor.secondaryText)
                    }
                }
            }
            Spacer()
                .frame(maxWidth: .infinity)
                .layoutPriority(-1)
            ScuolaActionButton(title: viewModel.isFollowing ? "Following" : "Follow", symbol: viewModel.isFollowing ? "heart.fill" : "heart", symbolColor: viewModel.isFollowing ? .red : BrandedColor.dynamicAccentColor, action: {
                onFollowTapped()
            })
        }
        .padding(.horizontal, 20)
    }
}
