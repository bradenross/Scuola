//
//  NotificationBanner.swift
//  Scuola
//
//  Created by Braden Ross on 3/4/24.
//

import SwiftUI

struct NotificationBanner: View {
    var title: String
    var message: String
    var imageName: String
    var backgroundColor: Color = .blue
    var textColor: Color = BrandedColor.text

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(message)
                    .font(.caption)
                    .foregroundColor(textColor)
            }
            Spacer()
        }
        .padding() // Add padding inside the banner
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15).fill(BrandedColor.foreground))
        .padding()
        .shadow(radius: 10)
   }
}
