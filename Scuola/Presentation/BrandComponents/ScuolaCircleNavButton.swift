//
//  ScuolaCircleNavButton.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct ScuolaCircleNavButton<Content: View>: View {
    var symbol: String
    var symbolSize: CGFloat = 30
    var type: String = "primary"
    var navigateTo: Content
    
    var body: some View {
        if(type.lowercased() == "secondary"){
            Button(action: {}){
                NavigationLink(destination: navigateTo) {
                    Image(systemName: symbol)
                        .font(.system(size: symbolSize))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
            }
        } else if(type.lowercased() == "primary"){
            Button(action: {}){
                NavigationLink(destination: navigateTo) {
                    Image(systemName: symbol)
                        .font(.system(size: symbolSize))
                        .frame(width: 50, height: 50)
                        .background(.white)
                        .foregroundColor(BrandedColor.dynamicAccentColor)
                        .cornerRadius(100)
                }
            }
        }
    }
}
