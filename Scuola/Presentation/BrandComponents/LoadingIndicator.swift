//
//  LoadingIndicator.swift
//  Scuola
//
//  Created by Braden Ross on 8/17/23.
//

import SwiftUI
import Lottie

struct LoadingIndicator: View {
    @State private var isAnimating = false
    var body: some View {
        LottieView(animation: .named("LoadingAnimation"))
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .loop)))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(){
                BrandedColor.background
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
