//
//  HomeVC.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/8.
//

import Foundation
import UIKit
import SnapKit


class HomeVC: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbar.snp.updateConstraints { make in
            make.height.equalTo(50)
        }
        _ = userProfile
        _ = searchView
        _ = editBtn
        _ = moreBtn
        _ = activityVC
        
        DispatchQueue.main.async {
           _ = self.mapBtn
        }
    }
    
    lazy var userProfile: UserProfile = {
        let profile = UserProfile()
        navigationbar.addSubview(profile)
        profile.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        return profile
    }()
    
    lazy var searchView: SearchView = {
        let search = SearchView()
        search.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 32))
        }
        navigationbar.stackView.addArrangedSubview(search)
        return search
    }()
    
    lazy var editBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage("outline_create_black_36pt_".image, for: .normal)
        button.tintColor = 0x666666.color
        navigationbar.stackView.addArrangedSubview(button)
        return button
    }()
    
    lazy var moreBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage("outline_more_vert_black_36pt_".image, for: .normal)
        button.tintColor = 0x666666.color
        navigationbar.stackView.addArrangedSubview(button)
        return button
    }()
    
    lazy var activityVC: ActivityVC = {
        let vc = ActivityVC()
        self.addChild(vc)
        safeView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationbar.snp.bottom)
        }
        return vc
    }()
    
    lazy var mapBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("outline_explore_black_36pt_".image, for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
        button.tapAction { _ in
            if self.mapPageVC.isPresented {
                self.dismissMap()
            } else{
                self.showMap()
            }
        }
        mapWindow.addSubview(button)
        button.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.bottom.equalTo(-60)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        return button
    }()
    
    lazy var mapWindow: MyWindow = {
        let mapWindow = MyWindow(frame: UIScreen.main.bounds)
        mapWindow.windowLevel = UIWindow.Level.normal + 1
        mapWindow.isHidden = false
        return mapWindow
    }()
        
    lazy var mapPageVC = MapPageVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
    func showMap() {
        mapPageVC.transitionAnimator.originPoint = mapBtn.center
        self.present(mapPageVC, animated: true)
    }
    
    func dismissMap(){
        mapPageVC.dismiss(animated: true)
    }
    
 
    
}



class MyWindow: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for v in subviews {
            if v.frame.contains(point){
                return true
            }
        }
        return false
    }
}
