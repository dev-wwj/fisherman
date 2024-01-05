//
//  UILable+Ex.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/12.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont = 17.font, textColor: UIColor = 0x222222.color) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
