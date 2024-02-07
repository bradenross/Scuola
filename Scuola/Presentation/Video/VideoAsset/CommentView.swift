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
                Text("\(commentInfo.user)")
                    .bold()
                Spacer()
                Text("\(getTimeFromDate(commentDate:commentInfo.date))")
            }
            Text("\(commentInfo.comment)")
        }
        .padding(15)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(commentInfo: Comment(user: "Billy Bob", comment: "This video kinda sucks lmao. I wish I could write a bigger comment because this is way too small for all the thoughts I have on my mind duhhhh. Oh my gosh this wasnt even big enough for the multiline shit", date: Date(timeIntervalSince1970: 169193909009)))
    }
}
