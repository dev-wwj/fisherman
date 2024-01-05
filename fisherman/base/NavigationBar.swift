//
//  NavigationBar.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/11.
//

import Foundation
import UIKit

class NavigationBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("outline_arrow_back_ios_black_36pt_".image, for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = 17.font(.medium)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        return stackView
    }()
}
