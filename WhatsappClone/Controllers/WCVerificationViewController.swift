//
//  WCVerificationViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 12.12.2023.
//

import UIKit
import FirebaseAuth

class WCVerificationViewController: UIViewController {
    
    let verificationView = WCVerificationView()
    var user: WCUser?
    
    init(user: WCUser?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(verificationView)
        setUpConstraints()
        prepareDoneButtonItem()
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            verificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verificationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            verificationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verificationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func prepareDoneButtonItem() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleTap))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func handleTap() {
        if let user = user {
            let code = verificationView.getText()
            if code.count == 6 {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: user.verificationID, verificationCode: code)
                Auth.auth().signIn(with: credential) { [weak self] authData, error in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Incorrect code!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self?.present(alert, animated: true)
                    }else{
                        let destinationVC = WCCreateProfileViewController()
                        destinationVC.modalPresentationStyle = .fullScreen
                        self?.navigationController?.pushViewController(destinationVC, animated: true)
                    }
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Code must be 6-digit!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            }
        }
    }
}

