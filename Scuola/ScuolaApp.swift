//
//  ScuolaApp.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let currentUser = Auth.auth().currentUser
        if(currentUser != nil && UserDefaults.standard.string(forKey: "uid") == nil){
            FirebaseAuthManager().signOut()
        }
        return true
    }
}

@main
struct ScuolaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    @ObservedObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack(){
                NavigationView {
                    switch sessionService.state {
                        case .loggedIn:
                            DashboardView()
                                .environmentObject(sessionService)
                        case .loggedOut:
                            LandingPage()
                        }
                    
                }
//                if(appState.isLoading){
//                    ZStack(){
//                        BrandedColor.backgroundGradient.opacity(0.5).ignoresSafeArea()
//                        ProgressView()
//                        LoadingIndicator()
//                    }
//                }
            }
        }
    }
}
