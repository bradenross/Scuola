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
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSS3StoragePlugin
import AWSDataStorePlugin
import Lottie

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let authenticationUseCase = AuthenticationUseCaseImpl()
        FirebaseApp.configure()
        let currentUser = Auth.auth().currentUser
        if(currentUser != nil && UserDefaults.standard.string(forKey: "uid") == nil){
            Task {
                await authenticationUseCase.signOut()
            }
        }
        
        do {
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Amplify failed to initialize: \(error)")
        }
        
        return true
    }
}

@main
struct ScuolaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    @ObservedObject var appState = AppState.shared
    
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var bannerManager = BannerManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top){
                if bannerManager.showBanner {
                    NotificationBanner(title: bannerManager.title, message: bannerManager.message, imageName: "Image(systemName: bannerManager.imageName)")
                        .transition(.move(edge: .top))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.25)) {
                                bannerManager.showBanner = false
                                bannerManager.bannerOffset = -100 // Ensure it moves off-screen
                            }
                        }
                        .zIndex(1)
                }
                
                NavigationView {
                    ZStack(){
                        if authViewModel.isAuthenticated {
                            DashboardView()
                        } else if authViewModel.needsConfirmation {
                            VerifyPage()
                        } else {
                            LandingPage()
                        }
                        
                        if authViewModel.isLoading {
                            LoadingIndicator()
                        }
                    }
                }
            }
            .environmentObject(authViewModel)
            .environmentObject(bannerManager)
        }
    }
}



