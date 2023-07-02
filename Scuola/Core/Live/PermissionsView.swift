//
//  PermissionsView.swift
//  Scuola
//
//  Created by Braden Ross on 7/1/23.
//

import SwiftUI
import AVFoundation

struct PermissionsView: View {
    
    @State private var permissionsManager = PermissionsManager()
    @State private var showingAlert = false
    
    var body: some View {
        VStack(){
            HStack(){
                Image("camera-mic-3d")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
            }
            Text("Camera and microphone permissions")
            Text("We need to access your microphone and camera for the stream")
            VStack(){
                Button(action: {
                    permissionsManager.requestCameraPermission { granted in
                        if granted {
                            
                        } else {
                            showingAlert = true
                        }
                    }
                }) {
                    Text("Request Camera Permission")
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Camera Permission"),
                message: Text("Camera access is required for this feature. Please enable camera access in the Settings app."),
                primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
