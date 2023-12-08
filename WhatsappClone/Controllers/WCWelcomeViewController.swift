//
//  WCWelcomeViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit
import SafariServices

class WCWelcomeViewController: UIViewController {
    
    private let welcomeView = WCWelcomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.addSubview(welcomeView)
        welcomeView.privacyTextView.delegate = self
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            welcomeView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            welcomeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            welcomeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

}


//MARK: - UITextViewDelegate Methods
extension WCWelcomeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        self.present(safariVC, animated: true)
        return false
    }
}
