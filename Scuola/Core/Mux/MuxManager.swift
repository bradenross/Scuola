//
//  MuxManager.swift
//  Scuola
//
//  Created by Braden Ross on 7/2/23.
//

import Foundation

struct MuxCredentials {
    static var accessKey: String {
        guard let accessKey = ProcessInfo.processInfo.environment["MUX_TOKEN_ID"] else {
            fatalError("Mux access key not found in environment variables")
        }
        return accessKey
    }
    
    static var secretKey: String {
        guard let secretKey = ProcessInfo.processInfo.environment["MUX_TOKEN_SECRET"] else {
            fatalError("Mux secret key not found in environment variables")
        }
        return secretKey
    }
}
