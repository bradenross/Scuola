//
//  VideoUploadInfoView.swift
//  Scuola
//
//  Created by Braden Ross on 2/25/24.
//

import SwiftUI

struct VideoUploadInfoView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var language: String = ""
    @State private var brandedContent: Bool = false
    @State private var contentWarning: Bool = false
    
    var body: some View {
        VStack(){
            
            Form {
                Section(header: Text("Stream Info")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Language", text: $language)
                }
                
                Section(header: Text("Branded Content"), footer: Text("Let users know if your content has branded content (Ads ran by you) inside your stream.")) {
                    FactoToggle(title: "Branded Content", isOn: brandedContent)
                }
                
                Section(header: Text("Content Warning"), footer: Text("Let users know if your content contains sensitive or mature content such as, but not limited to, drugs, weapons, gambling, etc.")){
                    FactoToggle(title: "Content Warning", isOn: contentWarning)
                }
            }
            
            ScuolaButton(title: "Upload Video", action: {})
        }
    }
}

#Preview {
    VideoUploadInfoView()
}
