//
//  VideoPostsView.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct VideoPostsView: View {
    @State var postIds: [String] = []
    var body: some View {
        VStack(){
            if(postIds.count == 0){
                Text("User has not posted yet!")
            } else {
                VStack(){
                    ForEach(postIds, id: \.self) { postID in
                        VideoPostItem(id: postID)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear(){
            postIds = ["vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", "vqzU9C6NOUuu21lJYOeG", ]
        }
    }
}
