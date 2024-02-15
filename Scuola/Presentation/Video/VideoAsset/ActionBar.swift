//
//  ActionBar.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ActionBar: View {
    @Binding var vote: Int
    @Binding var voteNum: Int
    @Binding var isSaved: Bool
    let interactionUseCase = UserInteractionUseCaseImpl()
    let videoDataUseCase = FetchVideoDataUseCaseImpl()
    
    private func onDislikedTapped(){
        var voteDiff = 0
        if(vote == -1){
            voteDiff = 1
            vote = 0
            voteNum += 1
        } else {
            if(vote == 0){
                voteDiff = -1
                voteNum -= 1
            } else {
                voteDiff = -2
                voteNum -= 2
            }
            vote = -1
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
                voteNum += 1
            } else {
                voteDiff = 2
                voteNum += 2
            }
            vote = 1
        }
        interactionUseCase.updateVideoVoteCount(videoID: "vqzU9C6NOUuu21lJYOeG", voteDiff: voteDiff)
    }
    
    private func onSaveTapped(){
        if(isSaved){
            interactionUseCase.removeSavedVideo(videoID: "vqzU9C6NOUuu21lJYOeG")
        } else {
            interactionUseCase.saveVideo(videoID: "vqzU9C6NOUuu21lJYOeG")
        }
        isSaved.toggle()
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
        .onAppear(){
            videoDataUseCase.isSaved(videoID: "vqzU9C6NOUuu21lJYOeG") { isVideoSaved in
                isSaved = isVideoSaved ? true : false
            }
            
            videoDataUseCase.getVotes(videoID: "vqzU9C6NOUuu21lJYOeG"){ numberOfVotes in
                voteNum = numberOfVotes
            }
        }
    }
}
