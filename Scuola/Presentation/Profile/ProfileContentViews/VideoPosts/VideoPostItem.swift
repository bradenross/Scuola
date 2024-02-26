//
//  VideoPostItem.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct VideoPostItem: View {
    @State private var isSheetShowing = false
    var videoThumbnail: Thumbnail
    var body: some View {
        Button(action: {
            isSheetShowing = true
        }) {
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    AsyncImage(url: URL(string: "https://image.mux.com/\(videoThumbnail.id)/thumbnail.png?width=1080&height=720&time=3")) { image in
                        ZStack(){
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 192, height: 108)
                                .overlay(){
                                    Color.black.opacity(0.3)
                                }
                                .blur(radius: 2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 192, height: 108)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } placeholder: {
                        ZStack(){
                            ProgressView()
                            RoundedRectangle(cornerRadius: 10)
                                .fill(BrandedColor.backgroundGradient)
                                .frame(width: 192, height: 108)
                        }
                        .padding(3)
                    }
                    VStack(alignment: .leading){
                        Text(videoThumbnail.title)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundStyle(BrandedColor.text)
                        Text(videoThumbnail.user)
                            .font(.subheadline)
                            .foregroundStyle(BrandedColor.secondaryText)
                        Text("\(suffixNumber(num: videoThumbnail.views)) Views")
                            .font(.subheadline)
                            .foregroundStyle(BrandedColor.secondaryText)
                    }
                    Spacer()
                }
                .padding(10)
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $isSheetShowing){
            VideoAssetView(videoThumbnailInfo: videoThumbnail)
        }
    }
}
