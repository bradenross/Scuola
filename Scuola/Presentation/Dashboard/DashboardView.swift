//
//  DashboardView.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var tabSelection = 0
    
    var body: some View {
        NavigationStack(){
            TabView(selection: $tabSelection){
                HomeScreen()
                    .tabItem {
                        Image(systemName: tabSelection == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                    .tag(0)
                
                ExploreView()
                    .tabItem {
                        Image(systemName: tabSelection == 1 ? "safari.fill" : "safari")
                        Text("Explore")
                    }
                    .tag(1)
                
                MediaUploadView()
                    .tabItem {
                        Image(systemName: tabSelection == 2 ? "plus.app.fill" : "plus.app")
                        Text("Create")
                    }
                    .tag(2)
                
                InboxView()
                    .tabItem {
                        Image(systemName: tabSelection == 3 ? "heart.fill" : "heart")
                        Text("Inbox")
                    }
                    .tag(3)
                
                ProfileView(accID: UserDefaults.standard.string(forKey: "uid") ?? "")
                    .tabItem {
                        Image(systemName: tabSelection == 4 ? "person.fill" : "person")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .toolbar {
                switch tabSelection {
                case 1:
                    ToolbarItem(placement: .principal){
                        Text("Explore")
                            .font(.custom("RadikalTrial-Medium", size: 20))
                    }
                case 3:
                    ToolbarItem(placement: .principal){
                        Text("Inbox")
                            .font(.custom("RadikalTrial-Medium", size: 20))
                    }
                case 4:
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink(destination: SettingsView()){
                            Image(systemName: "gearshape")
                        }
                    }
                default:
                    ToolbarItem(placement: .principal){
                        Text("Facto")
                            .font(.custom("RadikalTrial-Medium", size: 20))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
