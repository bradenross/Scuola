//
//  ProfileView.swift
//  Scuola
//
//  Created by Braden Ross on 8/6/23.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    var accID: String
    
    @State var isHeaderLoading: Bool = true
    
    @StateObject var viewModel: ProfileViewModel
    
    init(accID: String){
        self.accID = accID
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userID: accID))
    }
    
    private func loadData(){
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(){
                VStack(){
                    ProfileHeaderView(viewModel: viewModel)
                    ProfileContentView(viewModel: viewModel)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .refreshable {
//                try? await Task.sleep(nanoseconds: 1_000_000_000)
//                loadData()
//            }
        }
        .onAppear(){
            loadData()
        }
    }
}
