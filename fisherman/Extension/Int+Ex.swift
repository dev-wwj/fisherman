//
//  Int+ex.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/11.
//

import Foundation
import UIKit

extension Int {
    
    var font: UIFont {
        return self.font()
    }
    
    func font(_ weight: UIFont.Weight? = nil ) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self), weight: weight ?? .regular)
    }
    
    var color: UIColor {
        if self > 0xFFFFFF {
            return UIColor(rgbaHex: self)
        } else {
            return UIColor(rgbHex: self)
        }
    }
}
