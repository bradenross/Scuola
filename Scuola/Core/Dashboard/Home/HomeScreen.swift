//
//  HomeScreen.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import Firebase
import AVKit

struct HomeScreen: View {
    
    
    var body: some View {
        VStack(){
            Text("Test")
            Button(action: {Logout()}) {
                Text("Logout")
            }
        }
        
    }
    
    func Logout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
