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
                "senderPhone": message.sender,
                "text": message.text,
                "date": message.date,
                "receiver": message.reciever
            ]
            
            messagesCollection.addDocument(data: dataToAdd)
        }
        
    }
    
    func getMessages(receiver: String,_ completion: @escaping (Result<[WCMessage],Error>) -> Void) {
        
        var allMessages: [WCMessage] = []
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let messageCollection = db.collection("messages")
            let selfPhone = Auth.auth().currentUser?.phoneNumber ?? ""
            
            
            messageCollection.whereFilter(Filter.orFilter([
                Filter.andFilter([Filter.whereField("receiver", isEqualTo: receiver), Filter.whereField("senderPhone", isEqualTo: selfPhone)]),
                Filter.andFilter([Filter.whereField("receiver", isEqualTo: selfPhone), Filter.whereField("senderPhone", isEqualTo: receiver)])
            ]))
//            .order(by: "date")
            .getDocuments { snapshot, error in
                
                if error == nil {
                for doc in snapshot!.documents {
                    
                    let data = doc.data()
                    let text = data["text"] as! String
                    let sender = data["senderPhone"] as! String
                    let receiver = data["receiver"] as! String
                    let date = data["date"] as! Timestamp
                    let message = WCMessage(text: text,reciever: receiver, date: date, sender: sender)
                    allMessages.append(message)
                    print(text)
                }
                    completion(.success(allMessages))
                
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
    
}
