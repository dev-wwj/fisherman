//
//  ViewController.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/8.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }
    
    lazy var safeView: UIView = {
        let _view = UIView()
        view.addSubview(_view)
        _view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        return _view
    }()
    
    lazy var navigationbar: NavigationBar = {
        let navi = NavigationBar()
        safeView.addSubview(navi)
        navi.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        return navi
    }()
    
    override var title: String? {
        didSet {
            navigationbar.titleLabel.text = title
        }
    }
    
    
}

