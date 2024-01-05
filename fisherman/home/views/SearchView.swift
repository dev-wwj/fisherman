//
//  SearchView.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/11.
//

import Foundation
import UIKit

class SearchView: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = 0xEEEEEE.color
        self.clipsToBounds = true
        _ = imageView
        _ = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: "outline_search_black_36pt_".image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = 0x666666.color
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(text: "搜索", font: 15.font, textColor: 0x666666.color)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
}
