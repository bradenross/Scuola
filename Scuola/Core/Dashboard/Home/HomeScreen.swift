//
//  HomeScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import Firebase
import AVKit

struct HomeScreen: View {
    
    
    var body: some View {
        VStack(){
            AsyncImage(url: URL(string: "https://image.mux.com/3ZOQL2w7FW2301acK6dqxNI3w8J6Ibsb5Pj00A6bgFiIg/thumbnail.png?time=0")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            .frame(width: 100)
        }
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
