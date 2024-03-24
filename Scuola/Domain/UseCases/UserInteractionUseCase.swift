//
//  InteractionUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/8/24.
//

import Foundation
import Amplify
import AWSPluginsCore

protocol UserInteractionUseCase {
    func updateVideoVoteCount(videoID: String, voteDiff: Int, vote: ReactionType?) async
    func saveVideo(videoID: String) async
    func removeSavedVideo(videoID: String) async
    func userSubscribeToUser(userID: String)
    func userUnsubscribeToUser(userID: String) 
    func addCommentToVideo(videoID: String, comment: String) async
    // Note: Liking or disliking comments is not directly supported by the schema. Needs additional fields or models.
}

final class UserInteractionUseCaseImpl: UserInteractionUseCase {
    
    func updateVideoVoteCount(videoID: String, voteDiff: Int, vote: ReactionType?) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let userID = user.userId
            
            let queryResult = try await Amplify.API.query(request: .get(Video.self, byId: videoID))
            
            switch queryResult {
            case .success(let video):
                guard let video = video else {
                    print("Could not find Video")
                    return
                }
                print("Successfully got Video: \(video)")
                var updatedVideo = video
                updatedVideo.votes += voteDiff
                let userResult = try await Amplify.API.mutate(request: .update(updatedVideo))
                
                switch userResult {
                case .success(let reactionSuccess):
                    await updateVideoReaction(videoID: videoID, userID: userID, voteDiff: voteDiff, vote: vote)
                    
                    print("Successfully updated Video: \(updatedVideo)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
            print("Video vote count updated")
        } catch {
            print("Error updating video vote count: \(error)")
        }
    }
    
    func updateVideoReaction(videoID: String, userID: String, voteDiff: Int, vote: ReactionType?) async {
        let reaction = Reaction.keys
        let predicate = reaction.userID == userID && reaction.videoID == videoID
        let request = GraphQLRequest<Reaction>.list(Reaction.self, where: predicate, limit: 1)
        
        do {
            let result = try await Amplify.API.query(request: request)
            
            switch result {
            case .success(let reaction):
                if(!reaction.isEmpty){
                    if vote == nil {
                        // User is removing their reaction
                        let userResult = try await Amplify.API.mutate(request: .delete(reaction[0]))
                        print("Reaction removed successfully: \(userResult)")
                    } else {
                        // Update existing reaction if the new action is different
                        var updatedReaction = reaction[0]
                        updatedReaction.action = vote!
                        let userResult = try await Amplify.API.mutate(request: .update(updatedReaction))
                        print("Reaction updated successfully: \(userResult)")
                    }
                } else {
                    if vote != nil {
                        let newReaction = Reaction(action: vote!, videoID: videoID, userID: userID)
                        let createResult = try await Amplify.API.mutate(request: .create(newReaction))
                        print("New reaction created successfully: \(createResult)")
                    }
                }
            case .failure(let error):
                print("Error fetching reactions: \(error)")
            }
            
        } catch {
            print("Error processing reaction: \(error)")
        }
    }

    
    func saveVideo(videoID: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let userID = user.userId
            print("USERID: \(userID)")
            let queryResult = try await Amplify.API.query(request: .get(User.self, byId: userID))
            
            switch queryResult {
            case .success(let user):
                guard let user = user else {
                    print("Could not find User")
                    return
                }
                print("Successfully got User: \(user)")
                var updatedUser = user
                if(updatedUser.savedVideos == nil){
                    updatedUser.savedVideos = [videoID]
                } else {
                    updatedUser.savedVideos?.append(videoID)
                }
                let userResult = try await Amplify.API.mutate(request: .update(updatedUser))
                
                switch userResult {
                case .success(let user):
                    print("Successfully updated User: \(user)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as AuthError {
            print("AuthError: \(error)")
        } catch {
            print("Unexpected Error: \(error)")
        }
    }
    
    func removeSavedVideo(videoID: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let userID = user.userId

            // Query for the current user to get the existing list of saved videos
            let queryResult = try await Amplify.API.query(request: .get(User.self, byId: userID))
            
            switch queryResult {
            case .success(let user):
                guard var user = user else {
                    print("Could not find User")
                    return
                }
                print("Successfully got User: \(user)")

                // Remove the videoID from savedVideos if it exists
                if let index = user.savedVideos?.firstIndex(of: videoID) {
                    user.savedVideos?.remove(at: index)
                } else {
                    print("Video ID not found in savedVideos")
                    return
                }
                
                // Update the user with the modified list of saved videos
                let userResult = try await Amplify.API.mutate(request: .update(user))
                
                switch userResult {
                case .success(let updatedUser):
                    print("Successfully updated User: \(updatedUser)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as AuthError {
            print("AuthError: \(error)")
        } catch {
            print("Unexpected Error: \(error)")
        }
    }

    
    func userSubscribeToUser(userID: String) {
        // This example assumes you manage the followers/following relationship manually as your schema does not directly support it
        print("User subscribing functionality requires schema adjustments for proper many-to-many relationships.")
    }
    
    func userUnsubscribeToUser(userID: String) {
        // Similar to subscribing, this would also require schema adjustments or manual relationship management
        print("User unsubscribing functionality requires schema adjustments for proper many-to-many relationships.")
    }
    
    func addCommentToVideo(videoID: String, comment: String) async {
        
    }
    
    // Note: Implementing like/dislike functionality for comments would require additional schema design.
}
