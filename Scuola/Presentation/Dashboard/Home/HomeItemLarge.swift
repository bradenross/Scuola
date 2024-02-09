//
//  HomeItemLarge.swift
//  Scuola
//
//  Created by Braden Ross on 2/7/24.
//

import SwiftUI

struct HomeItemLarge: View {
    @State private var isSheetShowing = false
    var videoThumbnail: Thumbnail
    
    var body: some View {
        VStack(){
            ZStack(){
                AsyncImage(url: URL(string: "https://image.mux.com/\(videoThumbnail.id)/thumbnail.png?width=1080&height=720&time=3")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 167)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                }
                .opacity(0.5)
                
                AsyncImage(url: URL(string: "https://image.mux.com/\(videoThumbnail.id)/thumbnail.png?width=1080&height=720&time=3")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 167)
                
                VStack(){
                    HStack(){
                        if(videoThumbnail.live){
                            HStack(){
                                Text("Live")
                                    .foregroundStyle(.white)
                                Image(systemName: "shareplay")
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                            }
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.red)
                            }
                            .padding(10)
                        }
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    Spacer()
                        .frame(maxHeight: .infinity)
                    HStack(){
                        ZStack(){
                            AsyncImage(url: URL(string: videoThumbnail.channelLogo)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 50, maxHeight: 50)
                                    .shadow(color: .black, radius: 3)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .padding(5)
                        Spacer()
                        
                        HStack(){
                            Text("\(suffixNumber(num: videoThumbnail.views))")
                                .lineLimit(nil)
                                .foregroundStyle(.white)
                            Image(systemName: "eye")
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                        }
                        .fixedSize()
                        .frame(maxHeight: 10)
                        //.padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.black.opacity(0.4))
                        }
                        //.padding(.horizontal, 10)
                    }
                    .frame(maxHeight: 50)
                }
            }
            Text(videoThumbnail.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text(videoThumbnail.user)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .onTapGesture {
            isSheetShowing = true
        }
        .sheet(isPresented: $isSheetShowing){
            VideoAssetView(asset: VideoAsset(title: "What Am I Doing With My Life??", user: "Braden Ross", id: videoThumbnail.id))
        }
        .frame(width: 290, height: 210)
        .padding(15)
    }
}

#Preview {
    HomeItemLarge(videoThumbnail: Thumbnail(title: "This is a test video", user: "ESPN+", channelLogo: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/ESPN_logos.png?alt=media&token=38f7fd4e-1584-40a2-8065-b5f5bc23c793", views: 72700227, live: true, id: "ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE"))
}
