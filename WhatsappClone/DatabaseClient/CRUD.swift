//
//  CRUD.swift
//  WhatsappClone
//
//  Created by MacOS on 28.12.2023.
//

import Foundation
import CoreData
import UIKit

final class CRUD {
    
    static let shared = CRUD()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsappClone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Veri tabanı yüklenirken hata oluştu: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}

    func insertUserData(name: String, phoneNumber: String, image: Data? ) -> Bool{
        let context = self.persistentContainer.viewContext
        if let entitiy = NSEntityDescription.entity(forEntityName: "Users", in: context) {
            let newObject = NSManagedObject(entity: entitiy, insertInto: context)

            newObject.setValue(name, forKey: "name")
            newObject.setValue(phoneNumber, forKey: "phoneNumber")
            newObject.setValue(image, forKey: "image")

            do{
                try context.save()
                return true
            }catch{
                print("inserting failed")
            }

        }
        return false
    }
    
    func getUserData(phone: String) -> WCContact? {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        let predicate = NSPredicate(format: "phoneNumber == %@", phone)
        fetchRequest.predicate = predicate
        
        do{
            let items = try context.fetch(fetchRequest)
            for item in items {
                let name = item.value(forKey: "name") as! String
                let imageData = item.value(forKey: "image") as? Data
                let phoneNumber = item.value(forKey: "phoneNumber") as! String
                let contact = WCContact(name: name, phoneNumber: phoneNumber, image: imageData?.base64EncodedString())
                return contact
            }
        }catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getRooms() -> [WCRoom] {
        var rooms: [WCRoom] = []
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rooms")
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                let roomid = item.value(forKey: "roomid") as! String
                let user1 = item.value(forKey: "user1") as! String
                let user2 = item.value(forKey: "user2") as! String
                rooms.append(.init(roomid: roomid, user1: user1, user2: user2))
            }
        }catch {
            print(error.localizedDescription)
        }
        return rooms
    }
    
    func insertRoomToLocalStorage(_ room: WCRoom) {
        let context = self.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Rooms", in: context) {
            
            let newObject = NSManagedObject(entity: entity, insertInto: context)
            
            newObject.setValue(room.roomid, forKey: "roomid")
            newObject.setValue(room.user1, forKey: "user1")
            newObject.setValue(room.user2, forKey: "user2")
            
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func insertMessageToLocalStorage(_ message: WCMessage) {
        let context = self.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Mess", in: context) {
            
            let newObject = NSManagedObject(entity: entity, insertInto: context)
            
            if let image = message.image, let data = image.jpegData(compressionQuality: 1) {
                newObject.setValue(message.sender, forKey: "sender")
                newObject.setValue(message.reciever, forKey: "receiver")
                newObject.setValue(data, forKey: "image") //TODO: image to binary data
                newObject.setValue(message.roomid, forKey: "roomid")
                newObject.setValue(message.text, forKey: "text")
                newObject.setValue(message.date.dateValue(), forKey: "date")
            }else{
                newObject.setValue(message.sender, forKey: "sender")
                newObject.setValue(message.reciever, forKey: "receiver")
                newObject.setValue(nil, forKey: "image") //TODO: image to binary data
                newObject.setValue(message.roomid, forKey: "roomid")
                newObject.setValue(message.text, forKey: "text")
                newObject.setValue(message.date.dateValue(), forKey: "date")
            }
            
            do {
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func insertConversationToLocalStorage(_ conversation: WCConversation) {
        let context = self.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Conversations", in: context) {
            
            let newObject = NSManagedObject(entity: entity, insertInto: context)
            newObject.setValue(conversation.date.dateValue(), forKey: "date")
            newObject.setValue(conversation.roomid, forKey: "roomid")
            newObject.setValue(conversation.text, forKey: "text")
            newObject.setValue(conversation.contact.phoneNumber, forKey: "contactPhone")
            
            do {
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func getMessages(with roomid: String) -> [WCMessage] {
        
        var messages: [WCMessage] = []
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mess")
        let predicate = NSPredicate(format: "roomid == %@", roomid)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let items = try context.fetch(fetchRequest)
            
            for item in items {
                let text = item.value(forKey: "text") as! String
                let sender = item.value(forKey: "sender") as! String
                let receiver = item.value(forKey: "receiver") as! String
                let date = item.value(forKey: "date") as! Date
                let imageData = item.value(forKey: "image") as? Data
                let roomid = item.value(forKey: "roomid") as! String
                if let imageData = imageData {
                    let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: .init(date: date) , sender: sender, image: UIImage(data: imageData))
                    messages.append(message)
                    
                }else{
                    let message = WCMessage(roomid: roomid, text: text, reciever: receiver, date: .init(date: date) , sender: sender, image: nil)
                    messages.append(message)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return messages
    }
    
    func getConversation(with roomid: String) -> WCConversation? {
        
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Conversations")
        let predicate = NSPredicate(format: "roomid == %@", roomid)
        fetchRequest.predicate = predicate

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                let contactPhone = item.value(forKey: "contactPhone") as! String
                let date = item.value(forKey: "date") as! Date
                let text = item.value(forKey: "text") as! String
                let roomid = item.value(forKey: "roomid") as! String

                if let contact = getUserData(phone: contactPhone) {
                    let conversation = WCConversation(contact: contact, text: text, date: .init(date: date), roomid: roomid)
                    return conversation
                
                }
            }
        }catch {
            print(error.localizedDescription)

        }
        return nil
    }

    func deleteObjectFromLocalStorage(object: NSManagedObject, entityName: String) {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConversationFromLocaleStorage(roomid: String) {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Conversations")
        let predicate = NSPredicate(format: "roomid == %@", roomid)
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllRooms() {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rooms")
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func truncateDatabase() {
        
        do  {
            if let url = persistentContainer.persistentStoreDescriptions[0].url {
                try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
            }
            let container = NSPersistentContainer(name: "WhatsappClone")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Veri tabanı yüklenirken hata oluştu: \(error), \(error.userInfo)")
                }
            })
            persistentContainer = container
            WCContactsManagment.shared.removeObjectsFromLists()
        }catch {
            fatalError()
        }
//        let context = persistentContainer.viewContext
//        let fetchRequestCons = NSFetchRequest<NSManagedObject>(entityName: "Conversations")
//        let fetchRequestMess = NSFetchRequest<NSManagedObject>(entityName: "Mess")
//        let fetchRequestRooms = NSFetchRequest<NSManagedObject>(entityName: "Rooms")
//        let fetchRequestUsers = NSFetchRequest<NSManagedObject>(entityName: "Users")
//        do {
//            let conItems = try context.fetch(fetchRequestCons)
//            let mesItems = try context.fetch(fetchRequestMess)
//            let roomItems = try context.fetch(fetchRequestRooms)
//            let userItems = try context.fetch(fetchRequestUsers)
//            for conItem in conItems {
//                deleteObjectFromLocalStorage(object: conItem, entityName: "Conversations")
//            }
//            for mesItem in mesItems {
//                deleteObjectFromLocalStorage(object: mesItem, entityName: "Mess")
//            }
//            for roomItem in roomItems {
//                deleteObjectFromLocalStorage(object: roomItem, entityName: "Rooms")
//            }
//            for userItem in userItems {
//                deleteObjectFromLocalStorage(object: userItem, entityName: "Users")
//            }
//
//        }catch {
//            fatalError("fatal error! Error Truncating Database")
//        }
    }
}
