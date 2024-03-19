//
//  WCFirebaseCRUD.swift
//  WhatsappClone
//
//  Created by MacOS on 29.12.2023.
//

import Foundation
import FirebaseFirestore

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
    
    
}
