//
//  ScuolaButton.swift
//  Scuola
//
//  Created by Braden Ross on 8/13/23.
//

import SwiftUI

struct ScuolaButton: View {
    var title: String
    var type: String = "primary"
    var action: () -> Void
    
    var body: some View {
        if(type.lowercased() == "secondary"){
            Button(action: action) {
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
        } else if(type.lowercased() == "primary"){
            Button(action: action){
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
