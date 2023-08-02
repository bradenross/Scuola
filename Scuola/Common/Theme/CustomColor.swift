//
//  CustomColor.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import Foundation
import SwiftUI

struct ScuolaColor {
    static let color1 = Color("Color 1")
    static let color2 = Color("Color 2")
    static let color3 = Color("Color 3")
    static let color4 = Color("Color 4")
    static let foreground = Color("Foreground")
    static let background = Color("Background")
    static let text = Color("Text")
    
    static let backgroundGradient = LinearGradient(gradient: Gradient(colors: [ScuolaColor.color4, ScuolaColor.color3, ScuolaColor.color2, ScuolaColor.color1]), startPoint: .top, endPoint: .bottom)
    
    static let primaryButtonGradient = LinearGradient(gradient: Gradient(colors: [ScuolaColor.color1, ScuolaColor.color3]), startPoint: .leading, endPoint: .trailing)
    
}
