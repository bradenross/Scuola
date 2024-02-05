//
//  SettingsView.swift
//  Scuola
//
//  Created by Braden Ross on 7/8/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("accountPrivate") private var isAccountPrivate: Bool = false
    var body: some View {
        Form(){
            VStack(){
                Text("Username")
            }
            
            Section(){
                HStack(){
                    Image(systemName: "lock")
                    Toggle("Private", isOn: $isAccountPrivate)
                }
                HStack(){
                    Image(systemName: "clock")
                    Toggle("Time", isOn: $isAccountPrivate)
                }
                HStack(){
                    Image(systemName: "chart.xyaxis.line")
                    Button("Statistics"){
                        
                    }
                    .foregroundColor(.white)
                }
            } header: {
                Text("Account")
            }
            
            Section(){
                Text("Blocked")
            } header: {
                Text("User Management")
            }
            
            Section(){
                Button("Sign Out"){
                    FirebaseAuthManager().signOut()
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
