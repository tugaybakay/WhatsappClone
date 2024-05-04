//
//  WCConversation.swift
//  WhatsappClone
//
//  Created by MacOS on 3.05.2024.
//

import Foundation
import FirebaseFirestoreInternal

struct WCConversation {
    let contact: WCContact
    let text: String
    let date: Timestamp
    let roomid: String
}
