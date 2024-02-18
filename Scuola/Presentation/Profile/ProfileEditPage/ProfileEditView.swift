//
//  ProfileEditView.swift
//  Scuola
//
//  Created by Braden Ross on 2/16/24.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var username: String
    @State var name: String
    @State var bio: String
    @State var imageUrl: String = "https://firebasestorage.googleapis.com/v0/b/scuola-2d84c.appspot.com/o/apple-ceo-steve-jobs-speaks-during-an-apple-special-event-news-photo-1683661736.jpg?alt=media&token=3a8f817b-b582-417f-ab29-c269b3fdbc77"
    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture")){
                HStack(){
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
                    
                    Spacer()
                        .frame(width: 25)
                    
                    Button(action: {
                        
                    }){
                        Image(systemName: "camera")
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
            }
            
            Section(header: Text("Public Info")){
                TextField("Name", text: $name)
                TextField("Username", text: $username)
                TextEditor(text: $bio)
                    .frame(height: 125)
            }
        }
        .navigationBarHidden(false)
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        )
        .onTapGesture {
            // Dismiss keyboard when tapped outside of text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
