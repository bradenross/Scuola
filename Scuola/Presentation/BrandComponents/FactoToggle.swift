//
//  FactoToggle.swift
//  Scuola
//
//  Created by Braden Ross on 2/25/24.
//

import SwiftUI

struct FactoToggle: View {
    var title: String
    @State var isOn: Bool
    var body: some View {
        Toggle(title, isOn: $isOn)
            .toggleStyle(SwitchToggleStyle(tint: BrandedColor.dynamicAccentColor))
    }
}
