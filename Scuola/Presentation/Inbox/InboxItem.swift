//
//  InboxItem.swift
//  Scuola
//
//  Created by Braden Ross on 2/27/24.
//

import SwiftUI

struct InboxItem: View {
    var notification: Notification
    var body: some View {
        HStack(){
            Circle()
                .stroke(BrandedColor.background, lineWidth: 4)
                .frame(width: 50, height: 50)
                .overlay(
                    AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } placeholder: {
                        
                    }
                )
            VStack(alignment: .leading){
                Text("\(notification.message)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            if(notification.contentImage != nil){
                RoundedRectangle(cornerRadius: 10)
                    .stroke(BrandedColor.background, lineWidth: 4)
                    .frame(width: 25, height: 25)
                    .overlay(
                        AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            
                        }
                    )
            }
        }
    }
}
