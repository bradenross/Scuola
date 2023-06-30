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
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
