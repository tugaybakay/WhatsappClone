//
//  ContactsManagment.swift
//  WhatsappClone
//
//  Created by MacOS on 28.12.2023.
//

import UIKit
import Contacts


final class WCContactsManagment {
    
    static let shared = WCContactsManagment()
    
    private var allContacts: [WCContact] = []
    
    private var totalUsers: [WCContact] = [] {
        didSet{
            
        }
    }
    
    var filteredContacts: [WCContact] = []
    var contacts: [WCContact] = []
    var letters: [String] = []
    var lettersCounts: [Int] = []
    
    private init() {}
    
    func fetchAllContactsLocal() {
        let contactsStore = CNContactStore()
        contactsStore.requestAccess(for: .contacts) { [weak self] granted, error in
            if granted {
                let keysToFetch = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        try contactsStore.enumerateContacts(with: fetchRequest, usingBlock: { contact, _ in
                            let fullName = "\(contact.givenName) \(contact.familyName)"
                            let phoneNumbers = contact.phoneNumbers.map {
                                $0.value.stringValue
                            }
                            var phoneNumber = phoneNumbers.first ?? ""
                            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                            phoneNumber = phoneNumber.replacingOccurrences(of:"(", with: "")
                            phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                            let contact = WCContact(name: fullName, phoneNumber: phoneNumber)
                            self?.allContacts.append(contact)
                        })
                        WCFirabaseCRUD.shared.getAllUsers(completion: { contactsFromFirebase, error in
                            if error == nil {
                                if let contactsFromFirebase = contactsFromFirebase {
                                    for contact in self!.allContacts {
                                        for user in contactsFromFirebase {
                                            if user.phoneNumber == contact.phoneNumber {
                                            let myContact = WCContact(name: contact.name, phoneNumber: user.phoneNumber, image: user.image)
                                                self?.contacts.append(myContact)
                                            }
                                            
                                        }
                                    }
                                    self?.getLetters()
                                }
                                
                            }
                        })
                        
                    }catch {
                        print("Rehber alınırken hata oluştu: \(error.localizedDescription)")
                    }
                }
                
            }else {
                print("kullanıcı izin vermedi")
                let alert = UIAlertController(title: "Rehbere Erişim",
                                                              message: "Uygulamanın bazı özelliklerini kullanabilmek için rehber erişimi gerekiyor. Lütfen ayarlardan izini etkinleştirin.",
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
    
    private func getLetters() {
        let sortedContacts = contacts.sorted {
            $0.name < $1.name
        }
        contacts = sortedContacts
        var i = -1
        for r in contacts {
            if let char = r.name.first {
                let letter = String(describing: char)
                if !letters.contains(letter){
                    letters.append(letter)
                    i += 1
                    lettersCounts.append(1)
                }else{
                    lettersCounts[i] += 1
                }
            }
        }
        
        
    }
}

