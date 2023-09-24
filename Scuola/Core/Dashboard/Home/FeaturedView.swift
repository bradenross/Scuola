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
                    ForEach(getFeaturedSection(), id: \.self) { url in
                        HStack(){
                            FeaturedItem(imageUrl: url)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    func getFeaturedSection() -> [String]{
        
        
        
        return [""]
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
