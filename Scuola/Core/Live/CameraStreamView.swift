//
//  CameraStreamView.swift
//  Scuola
//
//  Created by Braden Ross on 7/2/23.
//

import SwiftUI
import AVFoundation

struct CameraStreamView: View {
    @ObservedObject private var cameraViewModel = CameraManager()
    @State private var videoTimer = 0.0
    @State private var isRecording = false
    
    var body: some View {
        ZStack(){
            if let previewLayer = cameraViewModel.previewLayer {
                PreviewView(layer: previewLayer)
                    .onAppear {
                        cameraViewModel.startCaptureSession()
                    }
                    .onDisappear {
                        cameraViewModel.stopCaptureSession()
                    }
            } else {
                Text("Camera Permission Granted")
            }
            VStack(){
                Text("\(videoTimer)")
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 3)
                    )
                ZStack(){
                    Circle()
                        .stroke(.white, lineWidth: 5)
                        .frame(width: 75, height: 75)
                    if(!isRecording){
                        Circle()
                            .fill(.red)
                            .frame(width: 65, height: 65)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: isRecording ? 0.5 : 0.2)))
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red)
                            .frame(width: 50, height: 50)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: isRecording ? 0.2 : 0.5)))
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isRecording.toggle()
                    }
                }
            }
        }
    }
}

struct PreviewView: UIViewRepresentable {
    let layer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        layer.frame = view.layer.bounds
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct CameraStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CameraStreamView()
    }
}
