//
//  UIButton+Ex.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/21.
//

import Foundation
import UIKit

extension UIControl {
    
    static var keyTapAction = "keyTapAction"
    
    func tapAction(_ action: @escaping(UIControl) -> Void) {
        self.tapActionBlock = action
        addTarget(self, action: #selector(tapActionFunc), for: .touchUpInside)
    }
    
    @objc private func tapActionFunc() {
        self.tapActionBlock?(self)
    }
    
    private var tapActionBlock: ((UIControl) -> Void)? {
        set {
            objc_setAssociatedObject(self, &Self.keyTapAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &Self.keyTapAction) as? ((UIControl) -> Void)
        }
    }
}
