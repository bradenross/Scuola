//
//  NotificationsPermissionPage.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import SwiftUI

struct NotificationsPermissionPage: View {
    @Binding var title: String
    
    var body: some View {
        HStack(){
            Spacer()
            VStack(){
                Text("Why turn on notifications?")
                    .font(.headline)
                    .bold()
                TabView(){
                    Text("🔔 Creators go live")
                    Text("💬 Messages from your friends instantly")
                    Text("📨 Interactions on your posts")
                }.tabViewStyle(PageTabViewStyle())
            }
            .frame(height: 200)
            .background(){
                BrandedColor.color1
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            Spacer()
        }
        .padding(15)
        .onAppear{
            title = "Notifications?"
            requestNotificationPermission()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Push notification permission granted")
                // You can handle the scenario when permission is granted
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
                // Handle the error case
            }
        }
    }
}
