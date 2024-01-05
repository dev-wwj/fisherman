//
//  ActivityCell.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/12.
//

import Foundation
import UIKit

class ActivityCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = imageView
        _ = label
        contentView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: "outline_image_black_36pt_".image)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
        }
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(text: "no data")
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        return label
    }()
    
    var cellData: CollectionCellData? {
        didSet {
            label.text = cellData?.identifier
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
