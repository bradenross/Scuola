//
//  FeaturedItem.swift
//  Scuola
//
//  Created by Braden Ross on 7/13/23.
//

import SwiftUI

struct FeaturedItem: View {
    var body: some View {
        VStack(){
            ZStack(){
                AsyncImage(url: URL(string: "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?time=0")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .opacity(0.5)
                .frame(height: 200)
                
                AsyncImage(url: URL(string: "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?time=0")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 200)
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
        .frame(width: 350, height: 250)
        .padding(15)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedItem()
    }
}
