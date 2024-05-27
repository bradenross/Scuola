//
//  ConversationView.swift
//  Scuola
//
//  Created by Braden Ross on 3/27/24.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var viewModel: ConversationViewModel = ConversationViewModel(conversationID: "26a1f9eb-6954-4c9a-b60c-85e95f415918")
    
    @State private var text: String = ""
    
    @State private var messages: [String] = [
        "This is a short test",
        "Short",
        "This is a test message that is hard coded and is not actually stored in the database hosted by AWS. I want to test this as a long one as well because I want to see what it looks like when the message bubble is a bit larger",
        "This is a medium short test that isnt too long or too short",
        "TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST",
        "Whats up dog?",
        "YEAH DOG WE GOT FLOW YEAH DOG",
        "South park has an all new episode coming out on wednesday",
        "NOW WAY dude thats insane",
        "wtf is wrong with you",
        "imma kms",
        "do it"
    ]
    
    var body: some View {
        VStack(){
            Spacer()
            if(viewModel.messageCount != 0){
                Text("No prior messages!")
                    .foregroundStyle(BrandedColor.secondaryText)
            } else {
                ScrollViewReader { value in
                    ScrollView(){
                        VStack(){
                            ForEach(0..<30, id: \.self) { message in
                                MessageView(message: messages[Int.random(in: 0...messages.count - 1)], isMe: Int.random(in: 1...2) == 1 ? true : false)
                                    .id(message)
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onAppear(){
                        value.scrollTo(29)
                    }
                }
            }
            Spacer()
            VStack(){
                HStack(){
                    TextField("Send a message...", text: $text)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .padding(15)
                        
                    Button(action: {
                        Task {
                            await viewModel.createMessage(content: text)
                        }
                    }){
                        Image(systemName: "arrow.up")
                            .foregroundStyle(BrandedColor.white)
                    }
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 20).fill(BrandedColor.dynamicAccentColor))
                }
                .padding(.horizontal, 5)
                .background(RoundedRectangle(cornerRadius: 20).fill(BrandedColor.foreground))
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 15)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(){
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.user.name)").font(.headline)
                        Text("@\(viewModel.user.username)").font(.subheadline)
                    }
                    ZStack(){
                        Circle()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 50, maxHeight: 50)
                            .overlay(
                                AsyncImage(url: URL(string: viewModel.user.picture ?? "")) { image in
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
            }
        }.onAppear(){
            viewModel.subscribeToConversation()
        }
        .onDisappear(){
            viewModel.unsubscribeToConversation()
        }
    }
}
