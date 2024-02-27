//
//  VideoUploadInfoView.swift
//  Scuola
//
//  Created by Braden Ross on 2/25/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct VideoUploadInfoView: View {
    @Binding var selectedVideo: PhotosPickerItem?
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var language: String = ""
    @State private var brandedContent: Bool = false
    @State private var contentWarning: Bool = false
    @State private var category: String = ""
    
    enum LoadState {
        case unknown, loading, loaded(Movie), failed
    }
    
    @State private var loadState = LoadState.unknown
    
    var body: some View {
        VStack(){
            Form {
                Section(header: Text("Preview")){
                    NavigationLink(destination: VideoPreview(selectedVideo: $selectedVideo)){
                        Text("Preview Video")
                    }
                }
                
                Section(header: Text("Stream Info")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Language", text: $language)
                }
                
                Section(header: Text("Category")){
                    NavigationLink(destination: CameraStreamView()){
                        Text("Select")
                    }
                }
                
                Section(header: Text("Branded Content"), footer: Text("Let users know if your content has branded content (Ads ran by you) inside your stream.")) {
                    FactoToggle(title: "Branded Content", isOn: brandedContent)
                }
                
                Section(header: Text("Content Warning"), footer: Text("Let users know if your content contains sensitive or mature content such as, but not limited to, drugs, weapons, gambling, etc.")){
                    FactoToggle(title: "Content Warning", isOn: contentWarning)
                }
                
                Section(footer: VStack(){
                    HStack(){
                        Spacer()
                        ScuolaButton(title: "Upload Video", action: {})
                        Spacer()
                    }
                    Text("By clicking upload, you are agreeing to our terms and policy on uploading media to the Facto servers and database.")
                }){}
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
