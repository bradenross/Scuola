//
//  LiveStreamView.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import SwiftUI
import AVKit

struct LiveStreamView: View {
    @State var permissionsGranted = false
    @State private var permissionsManager = PermissionsManager()
    @State private var showingAlert = false
    @State private var title: String = ""
    @State private var language: String = ""
    @State private var brandedContent: Bool = false

    var body: some View {
        VStack(){
            
            Form {
                Section(header: Text("Stream Info")) {
                    TextField("Title", text: $title)
                    TextField("Language", text: $language)
                }
                
                Section(header: Text("Branded Content"), footer: Text("Let users know if your content is going to have branded content (Ads ran by you) inside your stream.")) {
                    FactoToggle(title: "Branded Content", isOn: brandedContent)
                }
            }
            
            ScuolaButton(title: "Start Streaming!", action: {
                permissionsManager.requestCameraPermission { granted in
                    if granted {
                        permissionsGranted = true
                    } else {
                        showingAlert = true
                    }
                }
            })
        }
        .toolbar(.visible)
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

struct LiveStreamView_Previews: PreviewProvider {
    static var previews: some View {
        LiveStreamView()
    }
}
