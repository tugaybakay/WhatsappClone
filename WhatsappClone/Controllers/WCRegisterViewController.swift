//
//  WCRegisterViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit
import CountryPickerView
import FirebaseAuth

class WCRegisterViewController: UIViewController {
    
    
    let registerView = WCRegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.delegate = self
        prepareNavBar()
        setUpConstraints()
        prepareDoneButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Phone number"
    }
    
    private func prepareNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.lightText
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

//        navigationItem.hidesBackButton = false
//        navigationController?.navigationBar.barTintColor = .lightGray
        title = "Phone number"
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            registerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            registerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func prepareDoneButtonItem() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleTap))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func handleTap() {
        
        if let phoneNumber = registerView.getNumber(){
            self.title = "edit number"
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                if let error = error {
                    print("hata")
                }else{
                    let user = WCUser(verificationID: verificationID ?? "", phoneNumber: phoneNumber)
                    let destinationVC = WCVerificationViewController(user: user)
                    self?.navigationController?.pushViewController(destinationVC, animated: true)
                    self?.title = "edit number"
                }
            }
            print(phoneNumber)
        }else {
            
            let alert = UIAlertController(title: "Error", message: "You must enter the phone number!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            
        }
    }


}

extension WCRegisterViewController: WCRegisterViewDelegate {
    func wcRegisterView(didTap pickerView: CountryPickerView) {
        pickerView.showCountriesList(from: self.navigationController ?? self)
    }
}
