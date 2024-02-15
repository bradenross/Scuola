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
    func removeSavedVideo(videoID: String)
    func userSubscribeToUser(userID: String)
    func userUnsubscribeToUser(userID: String)
    func addCommentToVideo(videoID: String, comment: String)
    func likeComment(videoID: String, commentID: String)
    func dislikeComment(videoID: String, commentID: String)
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
        db.collection("users").document(userID).updateData(["savedVideos": FieldValue.arrayUnion([videoID])]) {
            error in
            if let error = error {
                print("Error updating savedVideos: \(error)")
            } else {
                print("Saved videos update successfully! \(videoID)")
            }
        }
    }
    
    func removeSavedVideo(videoID: String){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        print("User was found and we are adding \(videoID) to user \(userID)")
        db.collection("users").document(userID).updateData(["savedVideos": FieldValue.arrayRemove([videoID])]) {
            error in
            if let error = error {
                print("Error updating savedVideos: \(error)")
            } else {
                print("Saved videos update successfully! \(videoID)")
            }
        }
    }
    
    func userSubscribeToUser(userID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        
        let followersRef = db.collection("users").document(userID).collection("followers")
        let followingRef = db.collection("users").document(currentUserID).collection("following")
        
        followersRef.document(userID).setData([
            "timestamp": Timestamp()
        ]) { err in
            if let err = err {
                print("Error adding follower: \(err)")
            } else {
                print("Follower added successfully")
            }
        }
        
        followingRef.document(userID).setData([
            "timestamp": Timestamp() // Add timestamp if needed
        ]) { err in
            if let err = err {
                print("Error adding following: \(err)")
            } else {
                print("Following added successfully")
            }
        }
    }
    
    func userUnsubscribeToUser(userID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        // Reference to the followers collection under the specific user's document
        let followersRef = db.collection("users").document(userID).collection("followers")
        let followingRef = db.collection("users").document(currentUserID).collection("following")
        
        // Delete the document corresponding to the follower's ID
        followersRef.document(userID).delete { err in
            if let err = err {
                print("Error removing follower: \(err)")
            } else {
                print("Follower removed successfully")
            }
        }
        
        followingRef.document(userID).delete { err in
            if let err = err {
                print("Error removing follower: \(err)")
            } else {
                print("Follower removed successfully")
            }
        }
    }
    
    func addCommentToVideo(videoID: String, comment: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            return
        }
        
        let commentsRef = db.collection("videos").document(videoID).collection("comments")
        
        commentsRef.document(userID).setData([
            "timestamp": Timestamp() // Add timestamp if needed
        ]) { err in
            if let err = err {
                print("Error adding following: \(err)")
            } else {
                print("Comment added successfully")
            }
        }
    }
    
    func likeComment(videoID: String, commentID: String) {
        // Implementation for liking a comment
    }
    
    func dislikeComment(videoID: String, commentID: String) {
        // Implementation for disliking a comment
    }
}
