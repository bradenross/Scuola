//
//  FeaturedView.swift
//  Scuola
//
//  Created by Braden Ross on 7/13/23.
//

import SwiftUI

struct FeaturedView: View {
    var body: some View {
        VStack(){
            HStack(){
                Text("Featured")
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(1...10, id: \.self) { value in
                        HStack(){
                            FeaturedItem()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
