//
//  ActionBar.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ActionBar: View {
    @ObservedObject var viewModel: VideoAssetViewModel
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(){
                HStack(){
                    HStack(){
                        Image(systemName: viewModel.voteStatus?.action == .dislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(viewModel.voteStatus?.action == .dislike ? .red : .white)
                    }
                    .onTapGesture {
                        Task{
                            await viewModel.onDislikedTapped()
                        }
                    }
                    Divider()
                    Text("\(viewModel.videoInfo.votes)" as String)
                    Divider()
                    HStack(){
                        Image(systemName: viewModel.voteStatus?.action == .like ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(viewModel.voteStatus?.action == .like ? .green : .white)
                    }
                    .onTapGesture {
                        Task{
                            await viewModel.onLikedTapped()
                        }
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
                ScuolaActionButton(title: "Save", symbol: viewModel.isSaved ? "bookmark.fill" : "bookmark", symbolColor: viewModel.isSaved ? BrandedColor.dynamicAccentColor : BrandedColor.text, action: {Task{await viewModel.onSaveTapped()}})
                ScuolaActionButton(title: "Remove Ads", symbol: "sparkles.tv", action: {})
                ScuolaActionButton(title: "Download", symbol: "square.and.arrow.down", action: {})
                
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }
}
