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
    var isLoading: Bool = false
    var disabled: Bool = false
    
    var body: some View {
        if(!isLoading){
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
                .disabled(disabled)
            } else if(type.lowercased() == "primary"){
                Button(action: action){
                    Text(title)
                        .bold()
                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                        .background(.white)
                        .foregroundColor(BrandedColor.dynamicAccentColor)
                        .cornerRadius(100)
                }
                .disabled(disabled)
            } else if(type.lowercased() == "tertiary"){
                Button(action: action){
                    Text(title)
                        .bold()
                        .frame(maxWidth: 300, minHeight: 25, maxHeight: 25)
                        .background(.white)
                        .foregroundColor(BrandedColor.dynamicAccentColor)
                        .cornerRadius(5)
                }
                .disabled(disabled)
            }
        } else {
            if(type.lowercased() == "secondary"){
                Button(action: action) {
                    ProgressView()
                        
                }
                .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                .foregroundColor(.white)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 3)
                )
                .disabled(disabled)
            } else if(type.lowercased() == "primary"){
                Button(action: action){
                    ProgressView()
                }
                .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                .background(.white)
                .foregroundColor(BrandedColor.dynamicAccentColor)
                .cornerRadius(100)
                .disabled(disabled)
            } else if(type.lowercased() == "tertiary"){
                Button(action: action){
                    Text(title)
                        .bold()
                        .frame(maxWidth: 300, minHeight: 25, maxHeight: 25)
                        .background(.white)
                        .foregroundColor(BrandedColor.dynamicAccentColor)
                        .cornerRadius(5)
                }
                .disabled(disabled)
            }
        }
    }
}
