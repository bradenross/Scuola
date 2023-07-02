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
                    Image(systemName: "house")
                    Text("Home")
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
