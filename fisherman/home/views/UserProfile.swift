//
//  UserProfile.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/11.
//

import Foundation
import UIKit

class UserProfile: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        _ = imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(image: "".image)
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        }
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
}
