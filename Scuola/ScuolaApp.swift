//
//  ScuolaApp.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import FirebaseCore
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ScuolaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch sessionService.state {
                    case .loggedIn:
                        DashboardView()
                            .environmentObject(sessionService)
                    case .loggedOut:
                        LoginScreen()
                    }
                
            }
        }
    }
}
