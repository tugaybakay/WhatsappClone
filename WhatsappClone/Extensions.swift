//
//  Extensions.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
