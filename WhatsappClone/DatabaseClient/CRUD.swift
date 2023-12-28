//
//  CRUD.swift
//  WhatsappClone
//
//  Created by MacOS on 28.12.2023.
//

import Foundation
import CoreData

final class CRUD {
    
    static let shared = CRUD()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsappClone") // Veritabanı adı buraya yazılmalıdır
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Veri tabanı yüklenirken hata oluştu: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}

    func insertUserData(name: String?, phoneNumber: String?, image: Data? ) -> Bool{
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
                return false
            }
            
        }
        return false
    }
    
}
