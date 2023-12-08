//
//  WCWelcomeView.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit

class WCWelcomeView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }

}
