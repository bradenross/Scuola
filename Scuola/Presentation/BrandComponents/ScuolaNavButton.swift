//
//  ScuolaNavButton.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import SwiftUI

struct ScuolaNavButton<Content: View>: View {
    var title: String
    var type: String = "primary"
    var navigateTo: Content
    
    var body: some View {
        if(type.lowercased() == "secondary"){
            Button(action: {}) {
                NavigationLink(destination: navigateTo) {
                    Text(title)
                        .bold()
                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
            }
        } else if(type.lowercased() == "primary"){
            Button(action: {}) {
                NavigationLink(destination: navigateTo) {
                    Text(title)
                        .bold()
                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                        .background(.white)
                        .foregroundColor(BrandedColor.dynamicAccentColor)
                        .cornerRadius(100)
                }
            }
        }
    }
}
