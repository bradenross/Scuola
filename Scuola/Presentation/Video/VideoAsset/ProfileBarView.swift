//
//  ProfileBarView.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ProfileBarView: View {
    @Binding var isFollowing: Bool
    @Binding var accountData: Account?
    
    let interactionUseCase = UserInteractionUseCaseImpl()
    let videoDataUseCase = FetchVideoDataUseCaseImpl()
    
    private func onFollowTapped(){
        if(isFollowing){
            interactionUseCase.userUnsubscribeToUser(userID: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1")
        } else {
            interactionUseCase.userSubscribeToUser(userID: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1")
        }
        isFollowing.toggle()
    }
    
    var body: some View {
        HStack(){
            Button(action: {}){
                NavigationLink(destination: ProfileView(accId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1")){
                    Circle()
                        .frame(maxWidth: 50)
                    VStack(alignment: .leading){
                        Text("accountData!.name")
                            .foregroundColor(BrandedColor.text)
                        Text("49.3K Followers")
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
