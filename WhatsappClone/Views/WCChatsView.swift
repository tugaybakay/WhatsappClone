//
//  WCChatsView.swift
//  WhatsappClone
//
//  Created by MacOS on 22.12.2023.
//

import UIKit
import FirebaseAuth
import Contacts

protocol WCChatsViewDelegate: AnyObject {
    func didSelectRow(conversation: WCConversation)
}

final class WCChatsView: UIView {
    
    var viewModel: WCChatsViewViewModel?
    var delegate: WCChatsViewDelegate?
    
    var conversations: [WCConversation] = [] {
        didSet{
            conversations.sort {$0.date.dateValue() > $1.date.dateValue()}
            tableView.reloadData()
        }
    }

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WCChatsTableViewCell.self, forCellReuseIdentifier: "chatCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
        setUpConstraints()
        prepareTableView()
        
        WCFirabaseCRUD.shared.getRooms { result in
            switch result {
            case .success(let rooms):
                for room in rooms {
                    
                    WCFirabaseCRUD.shared.getLastMessages(roomid: room.roomid) { message in
                        if room.user1 == Auth.auth().currentUser?.phoneNumber, let message = message {
                            if let contactFromLocal = WCContactsManagment.shared.getContactName(phoneNumber: room.user2) {
                                let conversation = WCConversation(contact: contactFromLocal, text: message.text, date: message.date,roomid: room.roomid)
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
            case .failure:
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func prepareTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

}

extension WCChatsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! WCChatsTableViewCell
        cell.configure(with: conversations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 8
        return height
    }
}

extension WCChatsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(conversation: conversations[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
