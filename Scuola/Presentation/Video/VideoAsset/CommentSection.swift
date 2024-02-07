//
//  CommentSection.swift
//  Scuola
//
//  Created by Braden Ross on 7/17/23.
//

import SwiftUI

struct CommentSection: View {
    var body: some View {
        VStack(){
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(1...15, id: \.self) { value in
                        VStack(){
                            CommentView(commentInfo: Comment(user: "Billy Bob", comment: "This video kinda sucks lmao. I wish I could write a bigger comment because this is way too small for all the thoughts I have on my mind duhhhh. Oh my gosh this wasnt even big enough for the multiline shit", date: Date(timeIntervalSince1970: 169193909009)))
                            Divider()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct CommentSection_Previews: PreviewProvider {
    static var previews: some View {
        CommentSection()
    }
}
