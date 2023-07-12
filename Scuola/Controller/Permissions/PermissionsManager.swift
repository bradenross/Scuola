//
//  PermissionsManager.swift
//  Scuola
//
//  Created by Braden Ross on 7/2/23.
//

import Foundation
import AVFoundation

class PermissionsManager {
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined || status == .denied{
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .authorized {
            completion(true)
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted)
        }
    }


    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        // Set up the capture session.
    }
}
