//
//  VideoAssetViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/16/24.
//

import Foundation
import Amplify

class VideoAssetViewModel: ObservableObject {
    @Published var videoInfo: Video
    @Published var isFollowing: Bool = false
    @Published var voteStatus: Reaction?
    @Published var voteCount: Int = 0
    @Published var isSaved: Bool = false
    @Published var ownerAccountData: User = User(name: "", bio: "", birthdate: Temporal.DateTime(Date()), userType: "", username: "", verified: false)
    @Published var loading: Bool = true

    private let videoDataUseCase: FetchVideoDataUseCase
    private let interactionUseCase = UserInteractionUseCaseImpl()

    init(videoThumbnailInfo: Thumbnail, videoDataUseCase: FetchVideoDataUseCaseImpl) {
        self.videoDataUseCase = videoDataUseCase
        self.videoInfo = Video(id: videoThumbnailInfo.videoID, description: "", title: videoThumbnailInfo.title, views: 0, votes: 0, userID: "")
        loadVideoData(videoID: videoThumbnailInfo.videoID) 
    }

    private func loadVideoData(videoID: String) {
        Task {
            do {
                // Fetch video data asynchronously and await the result
                let videoData = try await videoDataUseCase.getVideoData(videoID: videoID)
                DispatchQueue.main.async {
                    self.videoInfo = videoData
                }
                
                // Once video data is fetched, fetch the owner's profile using the video's userID
                let ownerProfile = try await videoDataUseCase.getOwnerProfile(userID: videoData.userID)
                DispatchQueue.main.async {
                    self.ownerAccountData = ownerProfile
                    self.loading = false
                }
            } catch {
                DispatchQueue.main.async {
                    // Handle errors, potentially updating the UI to reflect the error state
                    print("Error loading video or owner profile: \(error)")
                    self.loading = false
                }
            }
        }

        
        videoDataUseCase.isUserFollowing(userID: "FP7uq0TiEJRFvekxVPJyCf0Lhbv1"){ isFollowingUser in
            self.isFollowing = isFollowingUser ? true : false
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
        
        if currentReaction.action == .dislike {
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
        
        if currentReaction.action == .like {
            await deleteReaction(currentReaction)
        } else {
            await createOrUpdateReaction(newAction: .like, currentReaction: currentReaction)
        }
    }

    private func createOrUpdateReaction(newAction: ReactionType, currentReaction: Reaction? = nil) async {
        DispatchQueue.main.async {
            self.voteStatus = Reaction(action: newAction, videoID: self.videoInfo.id, userID: "")
            self.videoInfo.votes += self.determineVoteChange(from: currentReaction?.action, to: newAction)
        }
        
        await interactionUseCase.updateVideoVoteCount(videoID: videoInfo.id, voteDiff: determineVoteChange(from: currentReaction?.action, to: newAction), vote: newAction)
    }
    
    private func deleteReaction(_ reaction: Reaction) async {
        do {
            DispatchQueue.main.async {
                self.voteStatus = nil
                let voteDiff = reaction.action == .like ? -1 : 1
                self.videoInfo.votes += voteDiff
            }
            await interactionUseCase.updateVideoVoteCount(videoID: videoInfo.id, voteDiff: reaction.action == .like ? -1 : 1, vote: nil)
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
