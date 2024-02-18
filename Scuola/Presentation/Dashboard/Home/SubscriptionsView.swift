//
//  SubscriptionsView.swift
//  Scuola
//
//  Created by Braden Ross on 2/7/24.
//

import SwiftUI

struct SubscriptionsView: View {
    var body: some View {
        VStack(){
            HStack(){
                Text("Favorites")
                    .font(Font.custom("RadikalTrial-Medium", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 10)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(getFeaturedSection(), id: \.self) { thumbnail in
                        HomeItemLarge(videoThumbnail: thumbnail)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    func getFeaturedSection() -> [Thumbnail]{
        
        
        
        return [Thumbnail(title: "This is a test video", user: "BallerTV", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 7227, live: false, id: "nD63z6qOLmlzpBb6iO1FOFd02pwauNnvojX00Qu3y9KD4"),
                Thumbnail(title: "This is a test video", user: "ESPN", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 486, live: true, id: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE"),
                Thumbnail(title: "This is a test video", user: "ESPN+", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 72700227, live: true, id: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg"),
                Thumbnail(title: "This is a test video", user: "Fox Sports", userId: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 89, live: true, id: "GO01ruRzL1FuuqBX602Ko00J7H02zCgtule3Ld93NYM9a4M")]
    }
}

#Preview {
    SubscriptionsView()
}
