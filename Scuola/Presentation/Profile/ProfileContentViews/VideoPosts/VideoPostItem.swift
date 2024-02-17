//
//  VideoPostItem.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct VideoPostItem: View {
    var id: String
    var body: some View {
        VStack(alignment: .leading){
            HStack(){
                AsyncImage(url: URL(string: "https://image.mux.com/ToSV6oyN00kQoT1VixiYNfW5OvgW4X1M6q6UjrSrC5nc/thumbnail.png?width=214&height=121&time=10")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    
                }
                VStack(alignment: .leading){
                    Text("I CAN'T BELIEVE I AHVE THIS AS A TEST TITLE\nfff\nasfasdf")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Text("Video Creator")
                        .font(.subheadline)
                        .foregroundStyle(BrandedColor.secondaryText)
                    Text("123.3k Views")
                        .font(.subheadline)
                        .foregroundStyle(BrandedColor.secondaryText)
                }
                Spacer()
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VideoPostItem(id: "")
}
