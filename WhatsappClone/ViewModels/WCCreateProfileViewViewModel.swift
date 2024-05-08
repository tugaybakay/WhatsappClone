//
//  WCCreateProfileViewViewModel.swift
//  WhatsappClone
//
//  Created by MacOS on 8.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class WCCreateProfileViewViewModel {
    
    func saveNewUser(name: String, image: UIImage? = nil) {
        DispatchQueue.main.async { [weak self] in
            let db = Firestore.firestore()
            let usersCollection = db.collection("users")
            
            let imageData = image?.jpegData(compressionQuality: 0.5)
            let base64Image = imageData?.base64EncodedString()
            let phoneNumber = Auth.auth().currentUser?.phoneNumber
            
            let dataToAdd: [String:Any] = [
                "name" : name,
                "number" : phoneNumber ?? "",
                "profileImage" : base64Image ?? ""
            ]

            usersCollection.addDocument(data: dataToAdd) { [weak self] error in
                if error == nil {
                    guard let strongSelf = self else { return }
                    
                    if CRUD.shared.insertUserData(
                        name: name,
                        phoneNumber: Auth.auth().currentUser?.phoneNumber ?? "",
                        image: image?.jpegData(compressionQuality: 0.5)) {
                        
                    }else{
                        fatalError()
                    }
                    
                }
            }
        }
    }
}
