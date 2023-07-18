//
//  CommentSectionPreview.swift
//  Scuola
//
//  Created by Braden Ross on 7/17/23.
//

import SwiftUI

struct CommentSectionPreview: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Braden Ross")
                .bold()
            Text("This video kinda sucks lmao. I wish I could write a bigger comment because this is way too small for all the thoughts I have on my mind duhhhh. Oh my gosh this wasnt even big enough for the multiline shit")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(){
            RoundedRectangle(cornerRadius: 15)
                .fill(.black)
        }
    }
}
