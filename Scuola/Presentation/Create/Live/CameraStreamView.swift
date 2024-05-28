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
    @State private var showingAlert = false
    
    @State var timerString = "00:00:00"
    @State var timerCount = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    func startRecording(){
        withAnimation {
            isRecording.toggle()
        }
    }
    
    func stopRecording(){
        isRecording = false
        timerCount = 0
        timerString = "00:00:00"
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let (h, m, s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
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
                Text("\(timerString)")
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white.opacity(0.5))
                    )
                    .padding(.vertical, 20)
                    .onReceive(timer) { _ in
                        if(isRecording){
                            timerCount += 1
                            timerString = "\(secondsToHoursMinutesSeconds(timerCount))"
                        }
                    }
                Spacer()
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
                .padding(.vertical, 20)
                .onTapGesture {
                    if(!isRecording){
                        startRecording()
                    } else {
                        showingAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Are you sure you want to stop your live stream?"),
                primaryButton: .default(Text("Stop").bold(), action: {
                    stopRecording()
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    print("Cancelled")
                })
            )
        }
        .onDisappear(){
            stopRecording()
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
