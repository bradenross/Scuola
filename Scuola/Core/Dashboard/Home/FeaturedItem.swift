//
//  FeaturedItem.swift
//  Scuola
//
//  Created by Braden Ross on 7/13/23.
//

import SwiftUI

struct FeaturedItem: View {
    @State private var isSheetShowing = false
    var body: some View {
        VStack(){
            ZStack(){
                AsyncImage(url: URL(string: "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?time=0")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .opacity(0.5)
                
                AsyncImage(url: URL(string: "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?time=0")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                
                VStack(){
                    Spacer()
                        .frame(maxHeight: .infinity)
                    HStack(){
                        Spacer()
                            .frame(maxWidth: .infinity)
                        HStack(){
                            Text("435")
                            Image(systemName: "eye.fill")
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                        }
                        .padding(10)
                    }
                }
            }
            Text("This is a title")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Streamer/Uploader")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .onTapGesture {
            isSheetShowing = true
        }
        .sheet(isPresented: $isSheetShowing){
            VideoAssetView(asset: VideoAsset(title: "Test video", user: "Braden Ross", id: "3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg"))
        }
        .frame(width: 350, height: 250)
        .padding(15)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedItem()
    }
}
