//
//  ContentView.swift
//  Scuola
//
//  Created by Braden Ross on 6/29/23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    var body: some View {
        VStack(){
            if(Auth.auth().currentUser != nil){
                HomeScreen()
            } else {
                LandingPage()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
