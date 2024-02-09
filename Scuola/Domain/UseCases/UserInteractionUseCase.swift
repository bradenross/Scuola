//
//  InteractionUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserInteractionUseCase {
    func updateVideoVoteCount(videoID: String, voteDiff: Int)
    func saveVideo(videoID: String)
    func subscribeToUser(userID: String)
    func addCommentToVideo(videoID: String, comment: String)
    func likeComment(commentID: String)
    func dislikeComment(commentID: String)
}

final class UserInteractionUseCaseImpl: UserInteractionUseCase {
    private let db = Firestore.firestore()
    
    func updateVideoVoteCount(videoID: String, voteDiff: Int) {
        let videoRef = db.collection("videos").document(videoID)
        videoRef.updateData(["votes": FieldValue.increment(Int64(voteDiff))])
    }
    
    func saveVideo(videoID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        print("User was found and we are adding \(videoID) to user \(userID)")
        let userRef = db.collection("users").document(userID).collection("savedVideos").document(videoID)
        userRef.setData(["saved": true])
    }
    
    func subscribeToUser(userID: String) {
        // Implementation for subscribing to a user's profile
    }
    
    func addCommentToVideo(videoID: String, comment: String) {
        // Implementation for adding a comment to a video
    }
    
    func likeComment(commentID: String) {
        // Implementation for liking a comment
    }
    
    func dislikeComment(commentID: String) {
        // Implementation for disliking a comment
    }
}
