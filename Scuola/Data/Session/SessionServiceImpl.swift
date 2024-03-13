//
//  SessionServiceImpl.swift
//  Scuola
//
//  Created by Braden Ross on 2/4/24.
//

import Foundation
import Combine
import Amplify

final class SessionServiceImpl: SessionService, ObservableObject {
    
    @Published var state: SessionState = .loggedOut
    
    init() {
        Task {
            await fetchCurrentAuthSession()
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
