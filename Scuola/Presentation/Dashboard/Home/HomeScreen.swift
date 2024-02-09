//
//  HomeScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import AVKit

struct HomeScreen: View {
    
    
    var body: some View {
        VStack(){
            FeaturedView()
            Spacer()
                .frame(height: 25)
            SubscriptionsView()
            Spacer()
                .frame(maxHeight: .infinity)
            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
