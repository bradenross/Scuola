//
//  CustomColor.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import Foundation
import SwiftUI

struct BrandedColor {
    static let dynamicAccentColor = Color("AccentColor")
    static let color1 = Color("Color 1")
    static let color2 = Color("Color 2")
    static let color3 = Color("Color 3")
    static let color4 = Color("Color 4")
    static let foreground = Color("Foreground")
    static let background = Color("Background")
    static let text = Color("Text")
    static let secondaryText = Color("SecondaryText")
    static let liveRed = Color("LiveRed")
    static let testBack = Color("TestBack")
    
    static let backgroundGradientColors = [BrandedColor.color4, BrandedColor.color3, BrandedColor.color2]
    
    static let backgroundGradient = LinearGradient(gradient: Gradient(colors: backgroundGradientColors), startPoint: .top, endPoint: .bottom)
    
    static let primaryButtonGradient = LinearGradient(gradient: Gradient(colors: [BrandedColor.color1, BrandedColor.color3]), startPoint: .leading, endPoint: .trailing)
    
    static let liveGradient = LinearGradient(gradient: Gradient(colors: [BrandedColor.liveRed, Color.red]), startPoint: .top, endPoint: .bottom)
    
}
