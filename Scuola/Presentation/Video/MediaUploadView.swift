//
//  MediaUploadView.swift
//  Scuola
//
//  Created by Braden Ross on 2/21/24.
//

import SwiftUI
import PhotosUI

struct MediaUploadView: View {
    
    @State var acc: Account = Account(id: "f9a2YDkrY6OfB5TtmQ0kxU8s5vD3", username: "", name: "", bio: "", followers: 0, following: 0, birthdate: Date(), userType: "default", verified: false, live: false, picture: "")
    @State var selectedVideo: PhotosPickerItem?
    
    var selectedVideoPresentedBinding: Binding<Bool> {
        return Binding<Bool>(
            get: { self.selectedVideo != nil },
            set: { newValue in
                // Optionally, you can set selectedVideo based on newValue if needed
                // For example, if you want to reset selectedVideo when newValue is false
                if !newValue {
                    self.selectedVideo = nil
                }
            }
        )
    }
    
    var body: some View {
        VStack(){
            VStack(alignment: .center){
                Image("FactoCreateWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)
                    .padding(.top, 50)
            }
            .padding(15)
            Spacer()
            VStack(spacing: 15){
                HStack(){
                    PhotosPicker(selection: $selectedVideo, matching: .videos){
                        Image(systemName: "square.and.arrow.up.fill")
                        VStack(alignment: .leading){
                            Text("Upload")
                                .fontWeight(.semibold)
                            Text("Upload a pre-recorded video")
                                .font(.callout)
                                .fontWeight(.light)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandedColor.foreground)
                )
                .padding(.horizontal, 30)
                
                HStack(){
                    NavigationLink(destination: LiveStreamView()){
                        Image(systemName: "video.fill")
                        VStack(alignment: .leading){
                            Text("Camera Stream")
                                .fontWeight(.semibold)
                            Text("Live stream from your camera")
                                .font(.callout)
                                .fontWeight(.light)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandedColor.foreground)
                )
                .padding(.horizontal, 30)
                
                HStack(){
                    NavigationLink(destination: LiveStreamView()){
                        Image(systemName: "iphone.smartbatterycase.gen2")
                        VStack(alignment: .leading){
                            Text("Screen Stream")
                                .fontWeight(.semibold)
                            Text("Live stream showing your screen")
                                .font(.callout)
                                .fontWeight(.light)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandedColor.foreground)
                )
                .padding(.horizontal, 30)
            }
            .fixedSize(horizontal: true, vertical: false)
            Spacer()
        }
        .navigationDestination(isPresented: selectedVideoPresentedBinding){
            VideoUploadInfoView(selectedVideo: $selectedVideo)
        }
    }
}
