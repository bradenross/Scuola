//
//  MessageViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/28/24.
//

import Foundation
class MessageViewModel: ObservableObject {
    @Published var userID: String
    @Published var userImageUrl: String
    @Published var message: String
    
    init(userID: String, userImageUrl: String, message: String) {
        self.userID = userID
        self.userImageUrl = userImageUrl
        self.message = message
    }
}
