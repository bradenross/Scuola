//
//  LoadingIndicator.swift
//  Scuola
//
//  Created by Braden Ross on 8/17/23.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating = false
    var body: some View {
        VStack(){
            ZStack(){
                Circle()
                    .stroke(BrandedColor.backgroundGradient, lineWidth: 5)
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(isAnimating ? 0 : 360), anchor: .center)
                
                Circle()
                    .fill(BrandedColor.backgroundGradient)
                    .frame(width: 20, height: 20)
                    .offset(y: -25)
                    .rotationEffect(.degrees(isAnimating ? 0 : 360), anchor: .center)
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
                            self.isAnimating.toggle()
                        }
                    }
                
            }
            
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
