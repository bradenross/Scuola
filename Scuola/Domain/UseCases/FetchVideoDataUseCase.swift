//
//  FetchVideoDataUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/9/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Amplify
import AWSPluginsCore

protocol FetchVideoDataUseCase {
    func getAllData(videoID: String) async
    func getVideoData(videoID: String) async throws -> Video
    func isSaved(videoID: String, completion: @escaping (Bool) -> Void)
    func isUserFollowing(userID: String, completion: @escaping (Bool) -> Void)
    func getUserVote(videoID: String) async -> Reaction?
    func getOwnerProfile(userID: String) async throws -> User
    func getComments(videoID: String, by: Int, completion: @escaping ([Comment]) -> Void)
}

final class FetchVideoDataUseCaseImpl: FetchVideoDataUseCase {
    private let db = Firestore.firestore()
    
    func getAllData(videoID: String) async{
        isSaved(videoID: videoID) { isSaved in
            if isSaved {
                print("Video is saved.")
            } else {
                print("Video is not saved.")
            }
        }
        await getUserVote(videoID: videoID)
    }
    
    func getVideoData(videoID: String) async throws -> Video {
        let queryResult = try await Amplify.API.query(request: .get(Video.self, byId: videoID))
        
        switch queryResult {
        case .success(let video):
            if let video = video {
                return video
            } else {
                throw NSError(domain: "com.yourapp", code: 404, userInfo: [NSLocalizedDescriptionKey: "Video not found"])
            }
        case .failure(let apiError):
            throw apiError
        }
    }




    func isSaved(videoID: String, completion: @escaping (Bool) -> Void){
        AppState.shared.isLoading = true
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Current user not available")
            completion(false)
            AppState.shared.isLoading = false
            return
        }
        
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let savedVideosArray = document.data()?["savedVideos"] as? [String] {
                    completion(savedVideosArray.contains(videoID))
                } else {
                    print("No savedVideos array found in the document")
                }
            } else {
                print("User document does not exist")
            }
        }
        completion(false)
        
        AppState.shared.isLoading = false
    }
    
    func isUserFollowing(userID: String, completion: @escaping (Bool) -> Void){
        AppState.shared.isLoading = true
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion(false)
            return
        }

        let followersRef = db.collection("users").document(currentUserID).collection("following")
        
        followersRef.document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error retrieving follower document: \(error)")
                completion(false)
                AppState.shared.isLoading = false
                return
            }
            
            if let _ = document, document!.exists {
                completion(true)
            } else {
                completion(false)
            }
            
            AppState.shared.isLoading = false
        }
    }
    
    func getUserVote(videoID: String) async -> Reaction? {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let userID = user.userId
            
            let reaction = Reaction.keys
            let predicate = reaction.userID.eq(userID) && reaction.videoID.eq(videoID) // Ensure correct syntax for predicates
            let request = GraphQLRequest<Reaction>.list(Reaction.self, where: predicate, limit: 1)
            
            let result = try await Amplify.API.query(request: request)
            
            switch result {
            case .success(let reactions):
                if let firstReaction = reactions.first {
                    return firstReaction
                }
            case .failure(let error):
                print("Error fetching reactions: \(error)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil // Return nil if no reaction is found or an error occurs
    }

    
    func getOwnerProfile(userID: String) async throws -> User {
        let queryResult = try await Amplify.API.query(request: .get(User.self, byId: userID))
        
        switch queryResult {
        case .success(let user):
            if let user = user {
                return user
            } else {
                throw NSError(domain: "com.yourapp", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
        case .failure(let apiError):
            throw apiError
        }
    }

    
    func getComments(videoID: String, by: Int, completion: @escaping ([Comment]) -> Void){
        AppState.shared.isLoading = true
        AppState.shared.isLoading = false
    }
}

struct UserData: Codable {
    var savedVideos: [String]
}
