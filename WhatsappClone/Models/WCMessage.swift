//
//  WCMessage.swift
//  WhatsappClone
//
//  Created by MacOS on 27.04.2024.
//

import Foundation
import FirebaseFirestoreInternal
 
struct WCMessage {
    let roomid: String
    let text: String
    let reciever: String
    let date: Timestamp
    let sender: String
    let image: UIImage?
}
