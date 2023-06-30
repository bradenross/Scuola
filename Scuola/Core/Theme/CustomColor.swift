//
//  CustomColor.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import Foundation
import SwiftUI

struct BrandColor {
    static let color1 = Color("Color 1")
    static let color2 = Color("Color 2")
    static let color3 = Color("Color 3")
    static let color4 = Color("Color 4")
    static let foreground = Color("Foreground")
    static let background = Color("Background")
    
    static let backgroundGradient = LinearGradient(gradient: Gradient(colors: [BrandColor.color4, BrandColor.color3, BrandColor.color2, BrandColor.color1]), startPoint: .top, endPoint: .bottom)
    
}
