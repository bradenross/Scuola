//
//  BannerManager.swift
//  Scuola
//
//  Created by Braden Ross on 3/4/24.
//

import SwiftUI

class BannerManager: ObservableObject {
    static let shared = BannerManager()
    
    @Published var showBanner: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var imageName: String = ""
    @Published var backgroundColor: Color = .blue
    @Published var textColor: Color = BrandedColor.text
    @Published var bannerOffset: CGFloat = 0

    func showBanner(title: String, message: String, imageName: String, backgroundColor: Color = .blue, textColor: Color = BrandedColor.text) {
        self.title = title
        self.message = message
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.showBanner = true
        withAnimation(.easeOut(duration: 1.0)) {
            self.showBanner = true
            self.bannerOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeIn(duration: 0.25)) {
                self.showBanner = false
                self.bannerOffset = -100
            }
        }
    }
}
