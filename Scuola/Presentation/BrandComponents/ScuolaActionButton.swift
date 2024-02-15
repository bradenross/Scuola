//
//  ScuolaActionButton.swift
//  Scuola
//
//  Created by Braden Ross on 8/2/23.
//

import SwiftUI

struct ScuolaActionButton: View {
    
    var title: String
    var symbol: String
    var symbolColor: Color = BrandedColor.text
    var backgroundColor: Color = BrandedColor.foreground
    var textColor: Color = BrandedColor.text
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(){
                if(title != ""){
                    Text(title)
                        .tint(textColor)
                }
                if(symbol != ""){
                    Image(systemName: symbol)
                        .tint(symbolColor)
                }
            }
            .padding(10)
            .background(){
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            }
        }
    }
}
