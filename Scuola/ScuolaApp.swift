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

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let authenticationUseCase = AuthenticationUseCaseImpl()
        FirebaseApp.configure()
        let currentUser = Auth.auth().currentUser
        if(currentUser != nil && UserDefaults.standard.string(forKey: "uid") == nil){
            authenticationUseCase.signOut()
        }
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
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
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack(){
                NavigationView {
                    if viewModel.isAuthenticated {
                        // User is authenticated, show the main content
                        DashboardView()
                    } else if viewModel.needsConfirmation {
                        // User needs to confirm sign-up
                        VerifyPage(viewModel: viewModel)
                    } else {
                        // Show login view
                        LandingPage(viewModel: viewModel)
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
