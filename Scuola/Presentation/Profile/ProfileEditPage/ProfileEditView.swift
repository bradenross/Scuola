//
//  ProfileEditView.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI
import PhotosUI
import Amplify

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    let editProfileUseCase = EditAccountUseCaseImpl()
    @State var username: String
    @State var name: String
    @State var bio: String
    @State var link: String = ""
    @State var imageUrl: String = "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/apple-ceo-steve-jobs-speaks-during-an-apple-special-event-news-photo-1683661736.jpg?alt=media&token=3a8f817b-b582-417f-ab29-c269b3fdbc77"
    @State var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture"), footer:
                PhotosPicker(selection: $selectedPhoto, matching: .images){
                    ZStack(){
                        Circle()
                            .stroke(BrandedColor.background, lineWidth: 4)
                            .frame(width: 100, height: 100)
                            .overlay(
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                } placeholder: {
                                    
                                }
                            )
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(BrandedColor.dynamicAccentColor)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Circle()
                                    .stroke(BrandedColor.backgroundGradient, lineWidth: 2)
                            )
                    }
                }
            ){
                
            }
            
            
            
            Section(header: Text("Public Info")){
                TextField("Name", text: $name)
                TextField("Username", text: $username)
                    .keyboardType(.namePhonePad)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextEditor(text: $bio)
                    .frame(height: 125)
                TextField("Link", text: $link)
            }
        }
        .navigationBarHidden(false)
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onDisappear(){
            let newData: User = User(name: name, bio: bio, birthdate: Temporal.DateTime(Date()), live: false, picture: "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/apple-ceo-steve-jobs-speaks-during-an-apple-special-event-news-photo-1683661736.jpg?alt=media&token=3a8f817b-b582-417f-ab29-c269b3fdbc77", userType: "", username: "", verified: false)
            Task {
                await editProfileUseCase.createTodo()
            }
        }
    }
}
