//
//  VideoPreview.swift
//  Scuola
//
//  Created by Braden Ross on 2/26/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct VideoPreview: View {
    @Binding var selectedVideo: PhotosPickerItem?
    
    enum LoadState {
        case unknown, loading, loaded(Movie), failed
    }
    
    @State private var loadState = LoadState.unknown
    
    var body: some View {
        VStack(){
            switch loadState {
            case .unknown:
                Text("TEST UNKNOWN")
            case .loading:
                ProgressView()
            case .loaded(let movie):
                VideoPlayer(player: AVPlayer(url: movie.url))
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failed:
                Text("Import failed")
            }
        }
        .onAppear {
            Task {
                do {
                    loadState = .loading

                    if let movie = try await selectedVideo?.loadTransferable(type: Movie.self) {
                        loadState = .loaded(movie)
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
        }
    }
}

struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie.mp4")

            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }

            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}
