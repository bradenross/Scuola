//
//  ScuolaApp.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct ScuolaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
