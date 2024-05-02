//
//  WCFirebaseCRUD.swift
//  WhatsappClone
//
//  Created by MacOS on 29.12.2023.
//

import Foundation
import FirebaseFirestore
import MessageKit
import FirebaseAuth


final class WCFirabaseCRUD {
    
    static let shared = WCFirabaseCRUD()
    let selfPhone = Auth.auth().currentUser?.phoneNumber ?? ""
    
    private init() {}
    
    func getAllUsers(completion: @escaping ([WCContact]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var users: [WCContact] = []
        db.collection("users").getDocuments { snapshot, error in
            if error == nil {
                for doc in snapshot!.documents {
                    let data = doc.data()
                    let name = data["name"] as? String ?? ""
                    let phoneNumber = data["number"] as? String ?? ""
                    let image = data["profileImage"] as? String
                    let contact = WCContact(name: name, phoneNumber: phoneNumber, image: image)
                    users.append(contact)
                }
                completion(users,nil)
            }else{
                print(error!.localizedDescription)
                completion(nil,error)
            }
        }
    }
    
    func sendMessage(_ message: WCMessage) {
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let messagesCollection = db.collection("messages")
            
           
            let dataToAdd: [String:Any] = [
                "roomid": message.roomid,
                "senderPhone": message.sender,
                "text": message.text,
                "date": message.date,
                "receiver": message.reciever
            ]
            
            messagesCollection.addDocument(data: dataToAdd)
        }
        
    }
    
    
    func getLastMessages(roomid: String,_ completion: @escaping (Result<WCMessage,Error>) -> Void) {
        
        
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let messageCollection = db.collection("messages")
            
            
            messageCollection.whereField("roomid", isEqualTo: roomid)
                .order(by: "date",descending: false)
                .limit(toLast: 1)
                .addSnapshotListener { snapshot, error in
                
                if error == nil {
                for doc in snapshot!.documents {
                    
                    let data = doc.data()
                    let text = data["text"] as! String
                    let sender = data["senderPhone"] as! String
                    let receiver = data["receiver"] as! String
                    let date = data["date"] as! Timestamp
                    let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: date, sender: sender)
//                    print(text)
                    completion(.success(message))
                    
                }
                    
            }else {
                print(error!.localizedDescription)
                completion(.failure(error!))
            }
        }

            
//            messageCollection
//                .whereField("receiver", isEqualTo: selfPhone)
//                .whereField("senderPhone", isEqualTo: selfPhone)
//                .getDocuments { snapshot, error in
//
//
//            }
        }
    }
    
    func getMessages(roomid: String,_ completion: @escaping (Result<[WCMessage],Error>) -> Void) {
        
        var allMessages: [WCMessage] = []
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let messageCollection = db.collection("messages")
            
            
            messageCollection.whereField("roomid", isEqualTo: roomid)
                .order(by: "date",descending: false)
                .addSnapshotListener { snapshot, error in
                
                if error == nil {
                for doc in snapshot!.documents {
                    
                    let data = doc.data()
                    let text = data["text"] as! String
                    let sender = data["senderPhone"] as! String
                    let receiver = data["receiver"] as! String
                    let date = data["date"] as! Timestamp
                    let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: date, sender: sender)
                    allMessages.append(message)
                }
                    completion(.success(allMessages))
                    allMessages.removeAll()
                    
            }else {
                print(error!.localizedDescription)
                completion(.failure(error!))
            }
        }

            
//            messageCollection
//                .whereField("receiver", isEqualTo: selfPhone)
//                .whereField("senderPhone", isEqualTo: selfPhone)
//                .getDocuments { snapshot, error in
//
//
//            }
        }
    }
    
    func getRooms(_ completion: @escaping (Result<[WCRoom],Error>) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("rooms")

        
        collection.whereFilter(Filter.orFilter([Filter.whereField("user1", isEqualTo: selfPhone), Filter.whereField("user2", isEqualTo: selfPhone)])).getDocuments { snapshot, error in
            if error == nil {
                let docs = snapshot!.documents
                var rooms: [WCRoom] = []
                for doc in docs {
                    let data = doc.data()
                    let user1 = data["user1"] as! String
                    let user2 = data["user2"] as! String
                    let roomid = data["roomid"] as! String
                    let room = WCRoom(roomid: roomid, user1: user1, user2: user2)
                    rooms.append(room)
                }
                completion(.success(rooms))
            }else {
                print(error!.localizedDescription)
                completion(.failure(error!))
            }
        }

    }
    
    
    
    func checkRoom(receiver: String, _ completion: @escaping (String?) -> Void) {
        
        let db = Firestore.firestore()
        let collection = db.collection("rooms")
        
        collection.whereFilter(Filter.orFilter([
            Filter.andFilter([Filter.whereField("user1", isEqualTo: selfPhone), Filter.whereField("user2", isEqualTo: receiver)]),
            Filter.andFilter([Filter.whereField("user1", isEqualTo: receiver), Filter.whereField("user2", isEqualTo: selfPhone)])
        ])).getDocuments { snap, error in
            if error == nil {
                let docs = snap!.documents
                if docs.isEmpty {
                    let roomid = UUID().uuidString
                    self.setRoom(roomid,receiver)
                    print("roomid from local \(roomid)")
                    completion(roomid)
                }else {
                    for doc in docs {
                        let data = doc.data()
                        let roomid = data["roomid"] as! String
                        print("roomid from firebase: \(roomid)")
                        completion(roomid)
                    }
                }
            }else {
                completion(nil)
            }
        }
    }
    
    func setRoom(_ roomid: String, _ receiver: String) {
        let db = Firestore.firestore()
        let collection = db.collection("rooms")
        
        let data: [String:Any] = ["roomid": roomid, "user1": receiver, "user2": selfPhone]
        collection.addDocument(data: data)
    }
}
