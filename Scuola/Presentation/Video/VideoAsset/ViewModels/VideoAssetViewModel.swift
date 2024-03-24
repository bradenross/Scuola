//
//  VideoAssetViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/16/24.
//

import Foundation

class VideoAssetViewModel: ObservableObject {
    @Published var videoInfo: Video
    @Published var isFollowing: Bool = false
    @Published var voteStatus: Reaction?
    @Published var voteCount: Int = 0
    @Published var isSaved: Bool = false
    @Published var ownerAccountData: Account = Account(id: "", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "default", verified: false, live: false, picture: "")

    private let videoDataUseCase: FetchVideoDataUseCase
    private let interactionUseCase = UserInteractionUseCaseImpl()

    init(videoThumbnailInfo: Thumbnail, videoDataUseCase: FetchVideoDataUseCaseImpl) {
        self.videoDataUseCase = videoDataUseCase
        // Initialize videoInfo and other properties as needed
        self.videoInfo = Video(id: videoThumbnailInfo.videoID, description: "", title: videoThumbnailInfo.title, views: 0, votes: 0, userID: "")
        // Fetch video data and other necessary information
        loadVideoData(videoID: videoThumbnailInfo.videoID) 
    }

    private func loadVideoData(videoID: String) {
        Task {
            do {
                let video = try await videoDataUseCase.getVideoData(videoID: videoID)
                DispatchQueue.main.async {
                    self.videoInfo = video
                    // Update other properties based on the fetched video data
                }
            } catch {
                // Handle errors
                print(error)
            }
        }
        
        videoDataUseCase.isUserFollowing(userID: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1"){ isFollowingUser in
            self.isFollowing = isFollowingUser ? true : false
        }
        
        Task {
            self.videoInfo = try await videoDataUseCase.getVideoData(videoID: videoID)
        }
        
        Task {
            let voteStatus = await videoDataUseCase.getUserVote(videoID: videoID)
            DispatchQueue.main.async {
                self.voteStatus = voteStatus
            }
        }
    }
    
    func onDislikedTapped() async {
        guard let currentReaction = voteStatus else {
            await createOrUpdateReaction(newAction: .dislike)
            return
        }
        
        // Toggle or change the reaction based on the current state
        if currentReaction.action == .dislike {
            // If already disliked, consider removing or toggling off the reaction
            print("222222222")
            await deleteReaction(currentReaction)
        } else {
            await createOrUpdateReaction(newAction: .dislike, currentReaction: currentReaction)
        }
    }

    func onLikedTapped() async {
        guard let currentReaction = voteStatus else {
            // Create a new like reaction if none exists
            await createOrUpdateReaction(newAction: .like)
            return
        }
        
        // Toggle or change the reaction based on the current state
        if currentReaction.action == .like {
            // If already liked, consider removing or toggling off the reaction
            await deleteReaction(currentReaction)
        } else {
            // Change the reaction to like
            await createOrUpdateReaction(newAction: .like, currentReaction: currentReaction)
        }
    }

    private func createOrUpdateReaction(newAction: ReactionType, currentReaction: Reaction? = nil) async {
        DispatchQueue.main.async {
            self.voteStatus = Reaction(action: newAction, videoID: self.videoInfo.id, userID: "")
            self.videoInfo.votes += self.determineVoteChange(from: currentReaction?.action, to: newAction)
        }
        // Implement logic to create a new reaction or update an existing one
        await interactionUseCase.updateVideoVoteCount(videoID: videoInfo.id, voteDiff: determineVoteChange(from: currentReaction?.action, to: newAction), vote: newAction)
    }
    
    private func deleteReaction(_ reaction: Reaction) async {
        do {
            DispatchQueue.main.async {
                self.voteStatus = nil
                let voteDiff = reaction.action == .like ? -1 : 1
                self.videoInfo.votes += voteDiff
            }
            // Assuming you have a method in your interaction use case to handle reaction deletion
            //try await interactionUseCase.updateVideoReaction(videoID: reaction.videoID, userID: reaction.userID, voteDiff: 0, vote: 0)
            await interactionUseCase.updateVideoVoteCount(videoID: videoInfo.id, voteDiff: reaction.action == .like ? -1 : 1, vote: nil)
            // Dispatching to the main thread to safely update ObservableObject's @Published property
        } catch {
            print("Failed to delete reaction: \(error)")
        }
    }
    
    private func determineVoteChange(from oldAction: ReactionType?, to newAction: ReactionType?) -> Int {
        if (oldAction == nil){
            return newAction == .like ? 1 : -1
        } else if (oldAction == .like){
            if(newAction == .dislike){
                return -2
            } else {
                return -1
            }
        } else {
            if(newAction == .like){
                return 2
            } else {
                return 1
            }

        }
    }
    
    func onSaveTapped() async{
        if(isSaved){
            await interactionUseCase.removeSavedVideo(videoID: videoInfo.id)
        } else {
            await interactionUseCase.saveVideo(videoID: videoInfo.id)
        }
        isSaved.toggle()
    }
}
