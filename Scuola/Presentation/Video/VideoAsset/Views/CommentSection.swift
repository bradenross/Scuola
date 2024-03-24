//
//  CommentSection.swift
//  Scuola
//
//  Created by Braden Ross on 7/17/23.
//

import SwiftUI
import Amplify

struct CommentSection: View {
    @State private var commentInput: String = ""
    @State private var isFilterButtonOpen: Bool = false
    var body: some View {
        VStack(){
            VStack(){
                HStack(){
                    Text("Comments")
                        .font(.title2)
                        .padding(.top, 15)
                    Spacer()
                }
                .padding(10)
                
                HStack(alignment: .center){
                    ScuolaActionButton(title: "Recent", symbol: "", action: {})
                    ScuolaActionButton(title: "Following", symbol: "", action: {})
                    ScuolaActionButton(title: "Votes", symbol: "", action: {})
                    Spacer()
                }
                .padding(10)
            }
            
            Divider()
            
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(1...15, id: \.self) { value in
                        VStack(){
                            CommentView(commentInfo: Comment(body: "This video kinda sucks lmao. I wish I could write a bigger comment because this is way too small for all the thoughts I have on my mind duhhhh. Oh my gosh this wasnt even big enough for the multiline shit", timestamp: Temporal.DateTime(Date(timeIntervalSince1970: 169193909009)), videoID: "", userID: ""))
//                            CommentView(commentInfo: Comment(id: "Billy Bob", body: "This video kinda sucks lmao. I wish I could write a bigger comment because this is way too small for all the thoughts I have on my mind duhhhh. Oh my gosh this wasnt even big enough for the multiline shit", timestamp: Date(timeIntervalSince1970: 169193909009)))
                            Divider()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            HStack(){
                TextField("Comment", text: $commentInput)
                    .padding(10)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(BrandedColor.foreground)
                    }
                ScuolaActionButton(title: "", symbol: "arrow.up", action: {})
            }
            .shadow(radius: 10)
            .padding(10)
        }
    }
}
