//
//  MediaUploadUseCase.swift
//  Scuola
//
//  Created by Braden Ross on 2/26/24.
//

import Foundation
import MuxUploadSDK
import PhotosUI
import _PhotosUI_SwiftUI
import Amplify
import AWSS3StoragePlugin

protocol MediaUploadUseCase {
    func uploadVideo(item: PhotosPickerItem)
}

final class MediaUploadUseCaseImpl: MediaUploadUseCase {
    func uploadVideo(item: PhotosPickerItem){
        
        getURL(item: item) { result in
            print("Result: \(result)")
            switch result {
            case .success(let url):
                print(url)
                Task {
                    do {
                        let resultMessage = try await self.uploadToS3(videoUrl: url)
                        print("Video has this result: \(resultMessage)")
                        // Update UI accordingly on success
                    } catch {
                        print("Error during upload: \(error)")
                        // Handle error, update UI as needed
                    }
                }
            case .failure(let error):
                print("Error getting video URL: \(error)")
            }
        }
    }
    
    private func uploadToS3(videoUrl: URL) async throws -> String {
        let videoFileName = "protected/tempVideos/\(UUID().uuidString).mov"

        let uploadTask = Amplify.Storage.uploadFile(
            key: videoFileName,
            local: videoUrl
        )

        for await progress in await uploadTask.progress {
            print("Progress: \(progress)")
        }

        do {
            let value = try await uploadTask.value
            print("Completed: \(value)")
            return "Upload successful for \(videoFileName)"
        } catch {
            print("Upload failed with error: \(error)")
            throw error
        }
    }

}

func uploadVideoChunksToLambda(videoURL: URL, videoFilePath: String) {
    let lambdaEndpoint = "https://kaa4wmutlajfuzegywfswfeuba0nmhpf.lambda-url.us-east-2.on.aws/"

    // Open the file handle for reading
    guard let fileHandle = try? FileHandle(forReadingFrom: videoURL) else {
        print("Failed to open file for reading")
        return
    }

    let chunkSize = 1024 * 1024 // 1 MB chunk size

    // Read data from the file in chunks and upload each chunk
    while true {
        // Read the chunk of data from the file
        let data = fileHandle.readData(ofLength: chunkSize)

        if data.isEmpty {
            // Reached the end of the file
            break
        }

        // Create the request
        var request = URLRequest(url: URL(string: lambdaEndpoint)!)
        request.httpMethod = "POST"
        let json: [String: Any] = ["videoFilePath": videoFilePath]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        // Add videoFilePath as a query parameter
        var urlComponents = URLComponents(string: lambdaEndpoint)!
        urlComponents.queryItems = [URLQueryItem(name: "videoFilePath", value: videoFilePath)]
        request.url = urlComponents.url


        // Create a new upload task for each chunk
        let uploadTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading chunk:", error)
                return
            }

            // Handle the response data if needed
            if let data = data {
                print("Response data:", String(data: data, encoding: .utf8) ?? "")
            }
        }
        uploadTask.resume()
    }

    // Close the file handle
    fileHandle.closeFile()
}

func getURL(item: PhotosPickerItem, completionHandler: @escaping (_ result: Result<URL, Error>) -> Void) {
    // Step 1: Load as Data object.
    item.loadTransferable(type: Data.self) { result in
        switch result {
        case .success(let data):
            if let contentType = item.supportedContentTypes.first {
                // Step 2: make the URL file name and a get a file extention.
                let url = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
                if let data = data {
                    do {
                        // Step 3: write to temp App file directory and return in completionHandler
                        try data.write(to: url)
                        completionHandler(.success(url))
                    } catch {
                        completionHandler(.failure(error))
                    }
                }
            }
        case .failure(let failure):
            completionHandler(.failure(failure))
        }
    }
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}
