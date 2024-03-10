//
//  SessionServiceImpl.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine
import Amplify

final class SessionServiceImpl: SessionService, ObservableObject {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: UserSessionDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupObservations()
        Task {
            await fetchCurrentAuthSession()
        }
    }
    
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit SessionServiceImpl")
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func setupObservations() {
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                self.state = currentUser == nil ? .loggedOut : .loggedIn
                
            }
    }
}

private extension SessionServiceImpl {
    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            DispatchQueue.main.async { [weak self] in
                print("Is user signed in - \(session.isSignedIn)")
                // Directly use the boolean value to update state
                self?.state = session.isSignedIn ? .loggedIn : .loggedOut
            }
        } catch let error as AuthError {
            DispatchQueue.main.async {
                print("Fetch session failed with error \(error)")
            }
        } catch {
            DispatchQueue.main.async {
                print("Unexpected error: \(error)")
            }
        }
    }
}
