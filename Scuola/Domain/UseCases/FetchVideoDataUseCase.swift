//
//  FetchVideoDataUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/9/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FetchVideoDataUseCase {
    func getAllData(videoID: String)
    func isSaved(videoID: String, completion: @escaping (Bool) -> Void)
    func isUserFollowing(userID: String, completion: @escaping (Bool) -> Void)
    func getUserVote(videoID: String)
    func getVotes(videoID: String, completion: @escaping (Int) -> Void)
    func getTimestamp(videoID: String)
    func getOwnerProfile(videoID: String, completion: @escaping (Result<Account, Error>) -> Void)
    func getComments(videoID: String, by: Int, completion: @escaping ([Comment]) -> Void)
}

final class FetchVideoDataUseCaseImpl: FetchVideoDataUseCase {
    private let db = Firestore.firestore()
    
    func getAllData(videoID: String){
        isSaved(videoID: videoID) { isSaved in
            if isSaved {
                print("Video is saved.")
            } else {
                print("Video is not saved.")
            }
        }
        getUserVote(videoID: videoID)
        getVotes(videoID: videoID){ isSaved in
            if isSaved == 0 {
                print("Video is saved.")
            } else {
                print("Video is not saved.")
            }
        }
        getTimestamp(videoID: videoID)
        getOwnerProfile(videoID: videoID){ isSaved in
            if isSaved != nil {
                print("Video is saved.")
            } else {
                print("Video is not saved.")
            }
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
    
    func getUserVote(videoID: String) {
        AppState.shared.isLoading = true
    }

    func getVotes(videoID: String, completion: @escaping (Int) -> Void) {
        AppState.shared.isLoading = true
        let videoRef = db.collection("videos").document(videoID)
        
        videoRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching video document: \(error)")
                completion(0)
                return
            }
            
            if let document = document, document.exists {
                if let votes = document.data()?["votes"] as? Int {
                    completion(votes)
                } else {
                    print("Votes field not found or not an integer")
                    completion(0)
                }
            } else {
                print("Video document does not exist")
                completion(0)
            }
        }
        
        AppState.shared.isLoading = false
    }
    
    func getTimestamp(videoID: String) {
        AppState.shared.isLoading = true
    }
    
    func getOwnerProfile(videoID: String, completion: @escaping (Result<Account, Error>) -> Void){
        AppState.shared.isLoading = true
        let videoRef = db.collection("videos").document(videoID)
            
        // Fetch the video document
        videoRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching video document: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                let customError = NSError(domain: "YourDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Video document does not exist"])
                completion(.failure(customError))
                return
            }
            
            // Fetch userID from the video document
            guard let userID = document.data()?["userID"] as? String else {
                let customError = NSError(domain: "YourDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "userID field not found or not a string"])
                completion(.failure(customError))
                return
            }
            
            // Use the retrieved userID to fetch the account data
//            getAccountFromFB(id: userID) { account in
//                if let account = account {
//                    // If account data is successfully fetched, pass it to the completion handler
//                    completion(.success(account))
//                } else {
//                    // If there's an error or account data is nil, create and pass an error object
//                    let customError = NSError(domain: "YourDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch account data"])
//                    completion(.failure(customError))
//                }
//            }
        }
        
        AppState.shared.isLoading = false
        
    }
    
    func getComments(videoID: String, by: Int, completion: @escaping ([Comment]) -> Void){
        AppState.shared.isLoading = true
        AppState.shared.isLoading = false
    }
}

struct UserData: Codable {
    var savedVideos: [String]
}
