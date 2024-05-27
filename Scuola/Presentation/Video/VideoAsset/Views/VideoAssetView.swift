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
    var videoThumbnailInfo: Thumbnail
    @StateObject private var viewModel: VideoAssetViewModel
    
    init(videoThumbnailInfo: Thumbnail) {
        _viewModel = StateObject(wrappedValue: VideoAssetViewModel(videoThumbnailInfo: videoThumbnailInfo, videoDataUseCase: FetchVideoDataUseCaseImpl()))
        self.videoThumbnailInfo = videoThumbnailInfo
    }
    
    @State private var isCommentSectionOpen = false
    
    private var testDesc = "gfhjkljlhgfklhgfklhgfklhgfasfjaksdhfkjashdfkjahsdfkasdfjkhaksjfhajkshfkjashfkjahsfdjkhasjkfhaljkfhakjhfjkahskjfhakjlfhakjlhfjkahfkjahskjfhajfhakjdhfkajhsdfkahsdfjkhasdkjfhakjsdhfkajshdfkahsdfkhakjsfhaksdhfkjasdhfjkashdfakljsdhfjakshfajksfhakjshfalksdfhaksjfhakjsfhaklshfakljshfakjsfhaksdhfaksjdfhakjlsdfhaskljfhaskjdfhajksfhajksdhfkajlshfklajshfjkalshfkjalsfhaksjldfhakjsfhakjsfhaklshfkjashfajkshfdaklsjdfhaskjl[bradenross.me](https://www.bradenross.me)dfhasflkjashfakljsfhaklsjdfhkashfalsjkdhfaklsjdhfjahsdklhasdfhaklsdhfkahsflkahsdflkahsdfkahsdflkhasdlkfhaksdfhkalsdhfklashflahsflashdflahsdfljkashdflkashdfjkashdfkjashdfklhasdfklhaifuaehnviibvsjdknasdvanvi"
    
    var body: some View {
        NavigationView(){
            VStack(){
                HStack(){
                    Text(viewModel.videoInfo.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(15)
                VideoPlayerView(videoURL: URL(string: "https://stream.mux.com/\(videoThumbnailInfo.muxID).m3u8")!)
                    .aspectRatio(1920/1080, contentMode: .fit)
                VStack(){
                    ScrollView(){
                        Spacer()
                            .frame(height: 15)
                        ProfileBarView(viewModel: viewModel)
                        ActionBar(viewModel: viewModel)
                        DescriptionView(description: testDesc)
                        
                        VStack(){
                            Text("AD SPACE")
                        }
                            .frame(maxWidth: .infinity, idealHeight: 100)
                            .padding(10)
                            .background(){
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(BrandedColor.foreground)
                            }
                            .padding(15)
                        
                        CommentSectionPreview()
                            .onTapGesture {
                                isCommentSectionOpen = true
                            }
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                }
                .sheet(isPresented: $isCommentSectionOpen){
                    CommentSection()
                        .presentationDetents([.medium, .large])
                        .presentationCompactAdaptation(.popover)
                }
            }
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
