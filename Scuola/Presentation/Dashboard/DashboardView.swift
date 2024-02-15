//
//  DashboardView.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import SwiftUI

struct DashboardView: View {
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "RadikalTrial-Medium", size: 20)!]
    }
    var body: some View {
        TabView(){
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            LiveStreamView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            LiveStreamView()
            
            
                .tabItem {
                    Image(systemName: "web.camera")
                    Text("Stream")
                }
            ProfileView(accId: UserDefaults.standard.string(forKey: "uid")!)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .navigationTitle("Facto")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
