//
//  InboxView.swift
//  Scuola
//
//  Created by Braden Ross on 2/26/24.
//

import SwiftUI

struct InboxView: View {
    @State var notifications: [Notification] = [Notification( message: "Testing the this message and seeing how it works when the lines are a lot longer for this and there are more words coming lets see how long it can go", profileImage: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"), Notification( message: "Testing the this message and seeing how it works when the lines are a lot longer for this and there are more words coming lets see how long it can go", profileImage: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"), Notification( message: "Testing the this message and seeing how it works when the lines are a lot longer for this and there are more words coming lets see how long it can go", profileImage: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"), Notification( message: "Testing the this message and seeing how it works when the lines are a lot longer for this and there are more words coming lets see how long it can go", profileImage: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"), Notification( message: "Testing the this message and seeing how it works when the lines are a lot longer for this and there are more words coming lets see how long it can go", profileImage: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/blank-profile-picture.webp?alt=media&token=8bb1bb7b-559c-4465-bbed-c3bf72f400e4"), ]
    
    var body: some View {
        VStack(){
            
            List {
                Section(header: Text("Messages")){
                    NavigationLink(destination: MessagesView()){
                        HStack(){
                            Text("3")
                                .padding(7)
                                .background(
                                    Circle()
                                        .fill(.red)
                                )
                            Text("New Messages")
                        }
                    }
                }
                
                Section(header: Text("Recent")){
                    ForEach(notifications, id: \.self) { notification in
                        InboxItem(notification: notification)
                    }
                }
                
                Section(header: Text("Older")){
                    ForEach(notifications, id: \.self) { notification in
                        InboxItem(notification: notification)
                    }
                }
            }
        }
    }
}
