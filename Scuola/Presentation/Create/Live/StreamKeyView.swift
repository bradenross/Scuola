//
//  StreamKeyView.swift
//  Scuola
//
//  Created by Braden Ross on 5/27/24.
//

import SwiftUI

struct StreamKeyView: View {
    private let streamKeyStars = "*********************"
    private let streamKeyValue = "Fetching StreamKey..."
    @State private var streamKey = "Fetching StreamKey..."
    @State private var streamKeyHidden = true
    var body: some View {
        VStack(){
            Spacer()
            Text(streamKeyHidden ? streamKeyStars : streamKeyValue)
            Spacer()
            Text("[Streaming Instructions](https://facto.live/instructions)")
            Spacer()
            ScuolaButton(title: streamKeyHidden ? "Show StreamKey" : "Hide StreamKey", action: {streamKeyHidden.toggle()})
                .padding(.bottom, 15)
            Text("WARNING: Do NOT share this StreamKey with anyone. Anyone with this StreamKey can access and take over your live streams.")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .padding(15)
    }
}
