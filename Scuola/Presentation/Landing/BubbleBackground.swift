//
//  BubbleBackground.swift
//  Scuola
//
//  Created by Braden Ross on 1/23/24.
//

import SwiftUI

struct BubbleBackground: View {
    @State var scale: CGFloat = 1
    @State var rand: CGFloat = 1
    var body: some View {
        ZStack(){
            ForEach(1...50, id: \.self) { i in
                Circle()
                    .foregroundColor(BrandedColor.backgroundGradientColors[Int.random(in: 0..<BrandedColor.backgroundGradientColors.count)])
                    .scaleEffect(CGFloat(i / 15), anchor: .center)
                    .shadow(color: .black.opacity(0.5), radius: CGFloat(i / 20))
                    .frame(width: CGFloat(i * 2),
                           height: CGFloat(i * 2),
                           alignment: .center)
                    .position(CGPoint(x: .random(in: 0...1112),
                                      y: .random (in:0...834)))
            }
        }
        .onAppear {
            self.scale = 1.2
        }
        .drawingGroup(opaque: false, colorMode: .linear)
                .background(
                    Rectangle()
                        .foregroundColor(BrandedColor.testBack))
                .ignoresSafeArea()
    }
}
