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
        if(type == "secondary"){
            Button(action: action) {
                Text(title)
                    .bold()
                    .frame(maxWidth: 300, maxHeight: 50)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 3)
                    )
            }
        } else {
            Button(action: action){
                Text(title)
                    .bold()
                    .frame(maxWidth: 300, maxHeight: 50)
                    .background(.white)
                    .foregroundColor(BrandedColor.color1)
                    .cornerRadius(100)
            }
        }
    }
}
