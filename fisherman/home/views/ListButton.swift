//
//  ListButton.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/22.
//

import Foundation
import UIKit

class TopDrawerButton: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = stateView
        _ = arrow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stateView: UIView = {
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
        return view
    }()
    
    lazy var arrow: UIImageView = {
        let imgView = UIImageView(image: "outline_expand_more_black_36pt_".image?.withRenderingMode(.alwaysTemplate))
        imgView.tintColor = UIColor.gray
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stateView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        return imgView
    }()
  
}
