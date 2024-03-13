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
    
    let videoDataUseCase = FetchVideoDataUseCaseImpl()
    
    @State private var isFollowing: Bool = false
    @State private var vote = 0
    @State private var voteNum = 0
    @State private var isSaved = false
    @State private var ownerAccountData: Account = Account(id: "", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "default", verified: false, live: false, picture: "")
    
    @State private var isCommentSectionOpen = false
    
    @State private var testDesc = "gfhjkljlhgfklhgfklhgfklhgfasfjaksdhfkjashdfkjahsdfkasdfjkhaksjfhajkshfkjashfkjahsfdjkhasjkfhaljkfhakjhfjkahskjfhakjlfhakjlhfjkahfkjahskjfhajfhakjdhfkajhsdfkahsdfjkhasdkjfhakjsdhfkajshdfkahsdfkhakjsfhaksdhfkjasdhfjkashdfakljsdhfjakshfajksfhakjshfalksdfhaksjfhakjsfhaklshfakljshfakjsfhaksdhfaksjdfhakjlsdfhaskljfhaskjdfhajksfhajksdhfkajlshfklajshfjkalshfkjalsfhaksjldfhakjsfhakjsfhaklshfkjashfajkshfdaklsjdfhaskjl[bradenross.me](https://www.bradenross.me)dfhasflkjashfakljsfhaklsjdfhkashfalsjkdhfaklsjdhfjahsdklhasdfhaklsdhfkahsflkahsdflkahsdfkahsdflkhasdlkfhaksdfhkalsdhfklashflahsflashdflahsdfljkashdflkashdfjkashdfkjashdfklhasdfklhaifuaehnviibvsjdknasdvanvi"
    
    var body: some View {
        NavigationView(){
            VStack(){
                HStack(){
                    Text(videoThumbnailInfo.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(15)
                VideoPlayerView(videoURL: URL(string: "https://stream.mux.com/\(videoThumbnailInfo.id).m3u8")!)
                    .aspectRatio(1920/1080, contentMode: .fit)
                VStack(){
                    ScrollView(){
                        Spacer()
                            .frame(height: 15)
                        ProfileBarView(isFollowing: $isFollowing, accountData: $ownerAccountData)
                        ActionBar(vote: $vote, voteNum: $voteNum, isSaved: $isSaved)
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
                .onAppear(){
                    
                    videoDataUseCase.isUserFollowing(userID: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1"){ isFollowingUser in
                        isFollowing = isFollowingUser ? true : false
                    }
                    
//                    getAccountFromFB(id: videoThumbnailInfo.userId) { account in
//                        if let account = account {
//                            print("Retrieved account: \(account)")
//                            ownerAccountData = account
//                        } else {
//                            print("Account not found or error occurred")
//                        }
//                    }
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
