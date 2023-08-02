//
//  ProfileBarView.swift
//  Scuola
//
//  Created by Braden Ross on 8/1/23.
//

import SwiftUI

struct ProfileBarView: View {
    var body: some View {
        HStack(){
            Text("Braden Ross")
            Spacer()
                .frame(maxWidth: .infinity)
            Button("Subscribe"){
                
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ProfileBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBarView()
    }
}
