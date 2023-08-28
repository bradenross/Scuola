//
//  ProfileBarView.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ProfileBarView: View {
    var body: some View {
        HStack(){
            Circle()
                .frame(maxWidth: 75)
            VStack(alignment: .leading){
                Text("Braden Ross")
                    .fontWeight(.bold)
                Text("49.3K Subscribers")
                    .fontWeight(.light)
                    .foregroundColor(BrandedColor.secondaryText)
            }
            Spacer()
                .frame(maxWidth: .infinity)
                .layoutPriority(-1)
            ScuolaActionButton(title: "Subscribe", symbol: "star", symbolColor: BrandedColor.dynamicAccentColor, action: {})
        }
        .padding(.horizontal, 20)
    }
}

struct ProfileBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBarView()
    }
}
