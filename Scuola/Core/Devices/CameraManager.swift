//
//  CameraManager.swift
//  Scuola
//
//  Created by Braden Ross on 7/2/23.
//

import Foundation
import AVFoundation

class CameraManager: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
    private var videoOutput: AVCaptureVideoDataOutput?

    @Published var previewLayer: AVCaptureVideoPreviewLayer?

    override init() {
        super.init()
        configureCaptureSession()
    }

    func startCaptureSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }

    func stopCaptureSession() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }

    private func configureCaptureSession() {
        sessionQueue.async {
            guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }

            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                if self.captureSession.canAddInput(videoInput) {
                    self.captureSession.addInput(videoInput)
                }

                let videoOutput = AVCaptureVideoDataOutput()
                if self.captureSession.canAddOutput(videoOutput) {
                    self.captureSession.addOutput(videoOutput)
                    self.videoOutput = videoOutput
                }

                let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer = previewLayer
            } catch {
                print("Error configuring capture session: \(error.localizedDescription)")
            }
        }
    }
}
