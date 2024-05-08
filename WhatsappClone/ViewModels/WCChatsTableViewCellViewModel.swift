//
//  WCChatsTableViewCellViewModel.swift
//  WhatsappClone
//
//  Created by MacOS on 8.05.2024.
//

import UIKit
import FirebaseFirestore

struct WCChatsTableViewCellViewModel {
    let name: String
    let message: String
    let image: String?
    let date: Timestamp
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let messageDate = date.dateValue()
        
        
        let today = Date.now
        let distance = today.distance(to: messageDate)
        if distance > -86400 {
            return "Today"
        }else if distance > -86400 * 2 {
            return "Yesterday"
        }else {
            let messageDateString = dateFormatter.string(from: messageDate)
            return messageDateString
        }
    }
}
