//
//  MessageView.swift
//  Scuola
//
//  Created by Braden Ross on 3/28/24.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var viewModel: MessageViewModel
    @State var isMe: Bool
    
    init(message: String, isMe: Bool) {
        self.viewModel = MessageViewModel(userID: "", userImageUrl: "", message: message)
        self.isMe = isMe
    }
    
    var body: some View {
        VStack(alignment: isMe ? .trailing : .leading){
            HStack(alignment: .bottom){
                if(!isMe){
                    ZStack(){
                        Circle()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, maxHeight: 30)
                            .overlay(
                                AsyncImage(url: URL(string: viewModel.userImageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                } placeholder: {
                                    LoadingIndicator()
                                        .clipShape(Circle())
                                }
                            )
                    }
                }
                Text(viewModel.message)
                    .padding(10)
                    .foregroundStyle(BrandedColor.white)
                    .background(){
                        RoundedRectangle(cornerRadius: 25)
                            .fill(isMe ? BrandedColor.color3 : BrandedColor.foreground)
                    }
            }
            .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
            .padding(.horizontal, 15)
            .padding(isMe ? .leading : .trailing, isMe ? 80 : 50)
        }
        .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
    }
}
