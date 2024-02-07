//
//  AppState.swift
//  Scuola
//
//  Created by Braden Ross on 8/17/23.
//

import Foundation

class AppState: ObservableObject {
    @Published var isLoading = false
    
    static let shared = AppState()
}
