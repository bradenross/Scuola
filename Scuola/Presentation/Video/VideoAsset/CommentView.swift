//
//  CommentView.swift
//  Scuola
//
//  Created by Braden Ross on 7/17/23.
//

import SwiftUI

struct CommentView: View {
    var commentInfo: Comment
    
    func getTimeFromDate(commentDate: Date) -> String{
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(commentDate)
        
        // Convert the time interval to a more human-readable format
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.maximumUnitCount = 1
            
        if let timeString = timeFormatter.string(from: timeInterval) {
            return "\(timeString)"
        } else {
            return "Unable to calculate the time."
        }
    }
    
    var body: some View {
        VStack(){
            HStack(){
                Text("\(commentInfo.userID)")
                    .bold()
                Spacer()
                Text("\(getTimeFromDate(commentDate: Date()))")
            }
            Text("\(commentInfo.body ?? "")")
        }
        .padding(15)
    }
}
