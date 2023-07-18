//
//  VideoAssetView.swift
//  Scuola
//
//  Created by Braden Ross on 7/16/23.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoAssetView: View {
    var asset: VideoAsset
    @State private var test = false
    var body: some View {
        VStack(){
            HStack(){
                Text(asset.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(15)
            VideoPlayerView(videoURL: URL(string: "https://stream.mux.com/\(asset.id).m3u8")!)
                        .frame(height: 300)
            VStack(){
                HStack(){
                    Text(asset.user)
                    Spacer()
                        .frame(maxWidth: .infinity)
                    Button("Subscribe"){
                        test = true
                    }
                }
                HStack(){
                    Image(systemName: "hand.thumbsup")
                    Text("354")
                    Divider()
                    Image(systemName: "hand.thumbsdown")
                    Text("543")
                    
                }
                .frame(height: 30)
                CommentSectionPreview()
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .sheet(isPresented: $test){
                CommentSection()
                    .presentationDetents([.medium, .large])
                    .presentationCompactAdaptation(.popover)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller if needed
    }
}
