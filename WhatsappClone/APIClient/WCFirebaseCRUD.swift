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
            
            if let image = message.image, let data = image.jpegData(compressionQuality: 0.4) {
                let base64Image = data.base64EncodedString()
                let dataToAdd: [String:Any] = [
                    "roomid": message.roomid,
                    "senderPhone": message.sender,
                    "text": "",
                    "date": message.date,
                    "receiver": message.reciever,
                    "image": base64Image
                ]
                messagesCollection.addDocument(data: dataToAdd)
            }else {
                let dataToAdd: [String:Any] = [
                    "roomid": message.roomid,
                    "senderPhone": message.sender,
                    "text": message.text,
                    "date": message.date,
                    "receiver": message.reciever,
                    "image": ""
                ]
                messagesCollection.addDocument(data: dataToAdd)
            }
           
            
            
           
        }
        
    }
    
    
    func getContact(phoneNumber: String, _ completion: @escaping (WCContact?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        
        collection.whereField("number", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if error == nil {
                let docs = snapshot!.documents
                for doc in docs {
                    let data = doc.data()
                    let name = data["name"] as! String
                    let number = data["number"] as! String
                    let profileImage = data["profileImage"] as! String
                    let contact = WCContact(name: name, phoneNumber: number, image: profileImage)
                    completion(contact)
                }
            }else {
                print(error!.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getLastMessages(roomid: String,_ completion: @escaping (WCMessage?) -> Void) {
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
                    var text = data["text"] as! String
                    let sender = data["senderPhone"] as! String
                    let receiver = data["receiver"] as! String
                    let date = data["date"] as! Timestamp
                    if text == "" {
                        text = "~Photo"
                    }
                    let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: date, sender: sender,image: nil)
//                    print(text)
                    completion(message)
                    
                }
                completion(nil)
                    
            }else {
                print(error!.localizedDescription)
                completion(nil)
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
                    let image = data["image"] as! String
                    
                    if text == "" {
                        if let data = Data(base64Encoded: image), let image = UIImage(data: data) {
                            let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: date, sender: sender, image: image)
                            allMessages.append(message)
                        }
                    }else {
                        let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: date, sender: sender, image: nil)
                        allMessages.append(message)
                    }
                    
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
                    completion(roomid)
                }else {
                    for doc in docs {
                        let data = doc.data()
                        let roomid = data["roomid"] as! String
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
    
    func checkUser(phoneNumber: String, _ completion: @escaping (Result<WCContact?,Error>) -> Void ) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        
        collection.whereField("number", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if error == nil {
                let docs = snapshot!.documents
                if docs.isEmpty{
                    completion(.success(nil))
                }
                for doc in docs {
                    let data = doc.data()
                    let name = data["name"] as! String
                    let profileImage = data["profileImage"] as! String
                    let user = WCContact(name: name, phoneNumber: phoneNumber, image: profileImage)
                    completion(.success(user))
                }
            }else {
                print(error!.localizedDescription)
                completion(.failure(error!))
            }
        }
    }
}
