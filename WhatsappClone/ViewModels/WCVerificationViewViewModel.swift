//
//  WCVerificationViewViewModel.swift
//  WhatsappClone
//
//  Created by MacOS on 8.05.2024.
//
import UIKit


final class WCVerificationViewViewModel {
    var user: WCUser?
    
    func checkPinCode(code: String, _ completion: @escaping (UIViewController?,UIAlertController?) -> Void) {
        if let user = user {
            if code.count == 6 {
                WCFirabaseCRUD.shared.signInWithCredential(user: user, code: code) { bool in
                    if bool {
                        WCFirabaseCRUD.shared.checkUser(phoneNumber: user.phoneNumber) { result in
                            switch result {
                            case .success(let user):
                                if let user = user {
                                    let destinationVC = WCTabBarController()
                                    destinationVC.modalPresentationStyle = .fullScreen
                                    completion(destinationVC,nil)
                                }else{
                                    let destinationVC = WCCreateProfileViewController()
                                    destinationVC.modalPresentationStyle = .fullScreen
                                    completion(destinationVC,nil)
                                }
                            case .failure:
                                break
                            }
                        }
                    }else {
                        
                    }
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Code must be 6-digit!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                completion(nil,alert)
            }
        }
    }
}
