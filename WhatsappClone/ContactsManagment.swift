//
//  ContactsManagment.swift
//  WhatsappClone
//
//  Created by MacOS on 28.12.2023.
//

import UIKit
import Contacts


final class ContactsManagment {
    
    static let shared = ContactsManagment()
    
    private init() {}
    
    func fetchAllContacts() {
        let contactsStore = CNContactStore()
        contactsStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                let keysToFetch = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        try contactsStore.enumerateContacts(with: fetchRequest, usingBlock: { contact, _ in
                            let fullName = "\(contact.givenName) \(contact.familyName)"
                            let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
                            print("Kişi: \(fullName), Telefon Numaraları: \(phoneNumbers.first)")
                        })
                    }catch {
                        print("Rehber alınırken hata oluştu: \(error.localizedDescription)")
                    }
                }
            }else {
                print("kullanıcı izin vermedi")
                let alert = UIAlertController(title: "Rehbere Erişim",
                                                              message: "Uygulamanın bazı özelliklerini kullanabilmek için rehber erişimi gerekiyor. Lütfen ayarlardan izni etkinleştirin.",
                                                              preferredStyle: .alert)
                                
                alert.addAction(UIAlertAction(title: "Ayarlar", style: .default, handler: { (_) in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:]) { _ in
                    }
                                }
                            }))
                                
                alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                                
                if let vc = UIApplication.shared.keyWindow?.rootViewController {
                    vc.present(alert, animated: true)
                }
            }
        }
        
    }
}

