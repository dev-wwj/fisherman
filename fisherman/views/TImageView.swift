//
//  TImageView.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/25.
//

import Foundation
import UIKit

class TImageView: UIImageView {
    
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return label
    }()
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    override var image: UIImage? {
        didSet {
            textLabel.isHidden = image != nil
        }
    }
    
}
