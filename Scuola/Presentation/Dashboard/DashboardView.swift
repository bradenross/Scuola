//
//  DashboardView.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView(){
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
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
        .rotationEffect(.degrees(0))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
