//
//  ActionBar.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ActionBar: View {
    @State private var vote = 0
    @State private var voteNum = 8435
    @State private var isSaved = false
    let interactionUseCase = UserInteractionUseCaseImpl()
    
    private func onDislikedTapped(){
        var voteDiff = 0
        if(vote == -1){
            voteDiff = 1
            vote = 0
            voteNum += 1
        } else {
            if(vote == 0){
                voteDiff = -1
            } else {
                voteDiff = -2
            }
            vote = -1
            voteNum -= 1
        }
        interactionUseCase.updateVideoVoteCount(videoID: "vqzU9C6NOUuu21lJYOeG", voteDiff: voteDiff)
    }
    
    private func onLikedTapped(){
        var voteDiff = 0
        if(vote == 1){
            voteDiff = -1
            vote = 0
            voteNum -= 1
        } else {
            if(vote == 0){
                voteDiff = 1
            } else {
                voteDiff = 2
            }
            vote = 1
            voteNum += 1
        }
        interactionUseCase.updateVideoVoteCount(videoID: "vqzU9C6NOUuu21lJYOeG", voteDiff: voteDiff)
    }
    
    private func onSaveTapped(){
        isSaved.toggle()
        interactionUseCase.saveVideo(videoID: "vqzU9C6NOUuu21lJYOeG")
    }
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(){
                HStack(){
                    HStack(){
                        Image(systemName: vote == 1 ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(vote == 1 ? .green : .white)
                    }
                    .onTapGesture {
                        onLikedTapped()
                    }
                    Divider()
                    Text("\(voteNum)" as String)
                    Divider()
                    HStack(){
                        Image(systemName: vote == -1 ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(vote == -1 ? .red : .white)
                    }
                    .onTapGesture {
                        onDislikedTapped()
                    }
                }
                .fixedSize()
                .padding(10)
                .background(){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandedColor.foreground)
                }
                Spacer()
                    .frame(maxWidth: .infinity)
                
                ScuolaActionButton(title: "Share", symbol: "arrowshape.turn.up.forward", action: {})
                ScuolaActionButton(title: "Save", symbol: isSaved ? "bookmark.fill" : "bookmark", symbolColor: isSaved ? BrandedColor.dynamicAccentColor : BrandedColor.text, action: {onSaveTapped()})
                ScuolaActionButton(title: "Remove Ads", symbol: "sparkles.tv", action: {})
                ScuolaActionButton(title: "Download", symbol: "square.and.arrow.down", action: {})
                
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }
}
