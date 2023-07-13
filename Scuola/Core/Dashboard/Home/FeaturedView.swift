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
            Text("Featured")
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...10, id: \.self) { value in
                        HStack(){
                            FeaturedItem()
                        }
                    }
                }
            }
        }
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
