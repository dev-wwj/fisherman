//
//  UIColor+Ex.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/11.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(rgbHex: Int) {
        let r = CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbHex & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgbHex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience init(rgbaHex: Int) {
        let r = CGFloat((rgbaHex & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgbaHex & 0xFF0000) >> 16) / 255.0
        let b = CGFloat((rgbaHex & 0xFF00) >> 8) / 255.0
        let a = CGFloat(rgbaHex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
