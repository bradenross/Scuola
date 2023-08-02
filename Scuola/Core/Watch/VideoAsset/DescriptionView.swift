//
//  DescriptionView.swift
//  Scuola
//
//  Created by Braden Ross on 7/26/23.
//

import SwiftUI

struct DescriptionView: View {
    var description: String
    
    @State private var isExpanded = false
    
    var body: some View {
        Button(action: {
            isExpanded.toggle()
        }) {
            VStack {
                Group {
                    if isExpanded {
                        HStack(alignment: .bottom) {
                            Text(LocalizedStringKey(description))
                                .multilineTextAlignment(.leading)
                                .tint(.white)
                            Image(systemName: "chevron.up")
                        }
                    } else {
                        HStack(alignment: .bottom) {
                            Text(LocalizedStringKey(description))
                                .multilineTextAlignment(.leading)
                                .tint(.white)
                            Image(systemName: "chevron.down")
                        }
                    }
                }
                .lineLimit(isExpanded ? nil : 3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15).fill(ScuolaColor.foreground)) // Lower opacity when expanded
        }
        .padding(.horizontal, 20)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(description: "This is a test for the description")
    }
}
