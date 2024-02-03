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
        
        
        
        return ["https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?width=214&height=121&time=3", "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?width=214&height=121&time=3", "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?width=214&height=121&time=3", "https://image.mux.com/ygmhdz5X01bhNaN3QzPf00TC1MfZ1JdYwBQ3xtgxuFZKE/thumbnail.png?width=214&height=121&time=6"]
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
