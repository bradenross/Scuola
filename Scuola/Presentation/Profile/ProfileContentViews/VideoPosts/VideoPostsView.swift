//
//  VideoPostsView.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct VideoPostsView: View {
    @State var postIds: [Thumbnail] = []
    @Binding var account: Account
    var body: some View {
        VStack(){
            if(postIds.count == 0){
                Text("User has not posted yet!")
            } else {
                VStack(){
                    if(account.live){
                        
                    }
                    ForEach(postIds, id: \.self) { postID in
                        VideoPostItem(videoThumbnail: postID)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear(){
            postIds = [Thumbnail(title: "This is a dtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "nD63z6qOLmlzpBb6iO1FOFd02pwauNnvojX00Qu3y9KD4", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a ftest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "GO01ruRzL1FuuqBX602Ko00J7H02zCgtule3Ld93NYM9a4M", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a gtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a htest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"), Thumbnail(title: "This is a ltest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "nD63z6qOLmlzpBb6iO1FOFd02pwauNnvojX00Qu3y9KD4", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a jtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "GO01ruRzL1FuuqBX602Ko00J7H02zCgtule3Ld93NYM9a4M", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a ntest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a btest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"), Thumbnail(title: "This is a test video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "nD63z6qOLmlzpBb6iO1FOFd02pwauNnvojX00Qu3y9KD4", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a vtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "GO01ruRzL1FuuqBX602Ko00J7H02zCgtule3Ld93NYM9a4M", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a ctest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a xtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"), Thumbnail(title: "oThis is a test video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "nD63z6qOLmlzpBb6iO1FOFd02pwauNnvojX00Qu3y9KD4", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a ztest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "GO01ruRzL1FuuqBX602Ko00J7H02zCgtule3Ld93NYM9a4M", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a qtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"),
                       Thumbnail(title: "This is a wtest video", user: "Test User", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: false, muxID: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE", videoID: "c212b33b-fe16-477d-9f4c-eb12f2a720d8"), ]
        }
    }
}
