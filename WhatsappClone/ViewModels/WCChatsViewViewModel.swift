//
//  WCChatsViewViewModel.swift
//  WhatsappClone
//
//  Created by MacOS on 22.12.2023.
//

import UIKit
import Network
import FirebaseAuth

final class WCChatsViewViewModel {
    
    var onUpdate: ((Bool) -> Void)?
    var cellViewModels: [WCChatsTableViewCellViewModel] = []
    
    var conversations: [WCConversation] = [] {
        didSet{
            conversations.sort {$0.date.dateValue() > $1.date.dateValue()}
            cellViewModels.removeAll()
            for con in conversations {
                cellViewModels.append(.init(name: con.contact.name, message: con.text, image: con.contact.image, date: con.date))
            }
            onUpdate?(true)
        }
    }
    
    init() {
        cellViewModels.removeAll()
        conversations.removeAll()
    }
    
    func getLastMessagesFromFirebase(room: WCRoom) {
        WCFirabaseCRUD.shared.getLastMessages(roomid: room.roomid) { message in
            //TODO: delete conversation
            CRUD.shared.deleteConversationFromLocaleStorage(roomid: room.roomid)
            if room.user1 == Auth.auth().currentUser?.phoneNumber, let message = message {
                if let contactFromLocal = WCContactsManagment.shared.getContactName(phoneNumber: room.user2) {
                    let conversation = WCConversation(contact: contactFromLocal, text: message.text, date: message.date,roomid: room.roomid)
                    CRUD.shared.insertConversationToLocalStorage(conversation)
                    if self.conversations.isEmpty {
                        self.conversations.append(conversation)
                        
                    }else {
                        var flag = 0
                        for i in 0...self.conversations.count-1 {
                            if self.conversations[i].roomid == room.roomid {
                                self.conversations[i] = conversation
                                flag = 1
                            }
                        }
                        if flag == 0{
                            self.conversations.append(conversation)
//                                            self.conversations.insert(conversation, at: 0)
                        }
                    }
                }else {
                    WCFirabaseCRUD.shared.getContact(phoneNumber: room.user2) { contact in
                        if var contact = contact {
                            let formattedPhoneNumber = WCContactsManagment.shared.formatPhoneNumber(phoneNumber: contact.phoneNumber)
                            contact.name = formattedPhoneNumber
                            let conversation = WCConversation(contact: contact, text: message.text, date: message.date,roomid: room.roomid)
                            CRUD.shared.insertConversationToLocalStorage(conversation)
                            if self.conversations.isEmpty {
                                self.conversations.append(conversation)
                                
                            }else {
                                var flag = 0
                                for i in 0...self.conversations.count-1 {
                                    if self.conversations[i].roomid == room.roomid {
                                        self.conversations[i] = conversation
                                        flag = 1
                                    }
                                }
                                if flag == 0{
                                    self.conversations.append(conversation)
//                                            self.conversations.insert(conversation, at: 0)
                                }
                            }
                            
//                                    self.conversations.append(conversation)
                        }
                    }
                }
                
            }else {
                if let contactFromLocal = WCContactsManagment.shared.getContactName(phoneNumber: room.user1) {
                    if let message = message {
                        let conversation = WCConversation(contact: contactFromLocal, text: message.text, date: message.date,roomid: room.roomid)
                        CRUD.shared.insertConversationToLocalStorage(conversation)
                        if self.conversations.isEmpty {
                            self.conversations.append(conversation)
                        }else {
                            var flag = 0
                            for i in 0...self.conversations.count-1 {
                                if self.conversations[i].roomid == room.roomid {
                                    self.conversations[i] = conversation
                                    flag = 1
                                }
                            }
                            if flag == 0{
                                self.conversations.append(conversation)
                            }
                        }
                        
//                                    self.conversations.append(conversation)
                    }
                }else {
                    WCFirabaseCRUD.shared.getContact(phoneNumber: room.user1) { contact in
                        if var contact = contact, let message = message {
                            let formattedPhoneNumber = WCContactsManagment.shared.formatPhoneNumber(phoneNumber: contact.phoneNumber)
                            contact.name = formattedPhoneNumber
                            let conversation = WCConversation(contact: contact, text: message.text, date: message.date,roomid: room.roomid)
                            CRUD.shared.insertConversationToLocalStorage(conversation)
                            if self.conversations.isEmpty {
                                self.conversations.append(conversation)
                            }else {
                                var flag = 0
                                for i in 0...self.conversations.count-1 {
                                    if self.conversations[i].roomid == room.roomid {
                                        self.conversations[i] = conversation
                                        flag = 1
                                    }
                                }
                                if flag == 0{
                                    self.conversations.append(conversation)
                                }
                            }
                            
//                                    self.conversations.append(conversation)
                        }
                    }
                }
            }
        }
    }
    
    func getConversations() {
        checkInternetConnection { [weak self] bool in
            if bool {
                self?.getRoomsFromLocal()
            }else{
                self?.getConversationsFromLocal()
            }
        }
    }
    
    
    func getRoomsFromLocal() {
        WCFirabaseCRUD.shared.getRooms { result in
            switch result {
            case .success(let rooms):
                for room in rooms {
                    self.getLastMessagesFromFirebase(room: room)
                }
            case .failure:
                break
            }
        }
    }
    
    func getConversationsFromLocal() {
        let rooms = CRUD.shared.getRooms()
        for room in rooms {
            if let conversation = CRUD.shared.getConversation(with: room.roomid) {
                self.conversations.append(conversation)
            }
        }
    }
    
    
    func checkInternetConnection(_ block: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                block(true)
            }else{
                block(false)
            }
            
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func getConversation(with index: Int) -> WCConversation{
        return conversations[index]
    }
    
    func subscribe(handler: @escaping (Bool) -> Void) {
        self.onUpdate = handler
    }
    
}


