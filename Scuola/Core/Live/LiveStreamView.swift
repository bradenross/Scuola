//
//  LiveStreamView.swift
//  Scuola
//
//  Created by Braden Ross on 6/30/23.
//

import SwiftUI
import AVKit

struct LiveStreamView: View {
    @State private var player = AVPlayer(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/pexels-anna-shvets-12691871%20(1440p).mp4?alt=media&token=e035b47f-e991-40f3-b21a-3ee8bca34965")!)
    @State var permissionsGranted = false
    @State private var permissionsManager = PermissionsManager()
    @State private var showingAlert = false

    var body: some View {
        ZStack(){
            VideoPlayer(player: player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaledToFill()
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    player.play()
                    player.allowsExternalPlayback = false
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }

                }
                .onDisappear(){
                    player.pause()
                }
            VStack(){
                Spacer()
                Button(action: { print("Stream Screen") }) {
                    Text("Stream Screen")
                        .bold()
                        .frame(maxWidth: 300, maxHeight: 50)
                        .background(ScuolaColor.primaryButtonGradient)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
                .padding(15)
                .shadow(radius: 3)
                
                Button(action: {
                    permissionsManager.requestCameraPermission { granted in
                        if granted {
                            permissionsGranted = true
                        } else {
                            showingAlert = true
                        }
                    }
                }) {
                    Text("Stream Camera")
                        .bold()
                        .frame(maxWidth: 300, maxHeight: 50)
                        .background(ScuolaColor.primaryButtonGradient)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .shadow(radius: 3)
                        .padding(15)
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
        .sheet(isPresented: $permissionsGranted) {
            CameraStreamView()
        }
            
    }
}

struct LiveStreamView_Previews: PreviewProvider {
    static var previews: some View {
        LiveStreamView()
    }
}
