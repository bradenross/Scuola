//
//  ActionBar.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ActionBar: View {
    @State private var liked = false
    @State private var disliked = true
    @State private var likedNum = 562
    @State private var dislikedNum = 8435
    @State private var isSaved = false
    
    private func onDislikedTapped(){
        if(disliked == false){
            if(liked == true){
                likedNum -= 1
            }
            liked = false
            disliked = true
            dislikedNum += 1
        } else {
            disliked = false
            dislikedNum -= 1
        }
    }
    
    private func onLikedTapped(){
        if(liked == false){
            if(disliked == true){
                dislikedNum -= 1
            }
            disliked = false
            liked = true
            likedNum += 1
        } else {
            liked = false
            likedNum -= 1
        }
    }
    
    private func onSaveTapped(){
        isSaved.toggle()
    }
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(){
                HStack(){
                    HStack(){
                        Image(systemName: liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(liked == true ? .green : .white)
                        Text("\(likedNum)" as String)
                    }
                    .onTapGesture {
                        onLikedTapped()
                    }
                    Divider()
                    HStack(){
                        Image(systemName: disliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(disliked == true ? .red : .white)
                        Text("\(dislikedNum)" as String)
                    }
                    .onTapGesture {
                        onDislikedTapped()
                    }
                }
                .fixedSize()
                .padding(10)
                .background(){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ScuolaColor.foreground)
                }
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Button(action: {}){
                    HStack(){
                        Text("Share")
                        Image(systemName: "arrowshape.turn.up.forward.fill")
                    }
                    .tint(ScuolaColor.text)
                    .padding(10)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ScuolaColor.foreground)
                    }
                }
                
                Button(action: {onSaveTapped()}){
                    HStack(){
                        Text("Save")
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    }
                    .tint(ScuolaColor.text)
                    .padding(10)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ScuolaColor.foreground)
                    }
                }
                
                Button(action: {}){
                    HStack(){
                        Text("Remove Ads")
                        Image(systemName: "sparkles.tv")
                    }
                    .tint(ScuolaColor.text)
                    .padding(10)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ScuolaColor.foreground)
                    }
                }
                
                Button(action: {}){
                    HStack(){
                        Text("Download")
                        Image(systemName: "square.and.arrow.down")
                    }
                    .tint(ScuolaColor.text)
                    .padding(10)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ScuolaColor.foreground)
                    }
                }
                
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }
}
