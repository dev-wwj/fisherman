//
//  MapPageVC.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/18.
//

import UIKit
import MAMapKit
import AMapLocationKit

class MapPageVC: UIPageViewController {
    let transitionAnimator = TransitionAnimator()

    var currentLoc: CLLocation?
    
    var maps: [UIViewController] = {
        let map1 = WildFishingMapVC()
        let map2 = BlackHoleMapVC()
        return [map1, map2]
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MAMapView.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        MAMapView.updatePrivacyAgree(.didAgree)
        if let selectedIndex = UserDefaults.standard.integer(forKey: "Defaults_Map_Selected") as? Int {
            setViewControllers([maps[selectedIndex]], direction: .forward, animated: false)
            segmentedControl.selectedSegmentIndex = selectedIndex
        } else {
            setViewControllers([maps[1]], direction: .forward, animated: false)
            segmentedControl.selectedSegmentIndex = 1
        }
        _ = locationBtn
        locationManager.startUpdatingLocation()
        locationManager.requestLocation(withReGeocode:true) { [weak self] location, _, _ in
            self?.currentLoc = location
            self?.localRefresh()
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["野钓", "黑坑"])
        segmentedControl.backgroundColor = .white.withAlphaComponent(0.6)
        segmentedControl.addTarget(self, action: #selector(segmentedContrlAction), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        return segmentedControl
    }()
    
    @objc func segmentedContrlAction(_ sender: UISegmentedControl) {
        view.bringSubviewToFront(sender)
        if sender.selectedSegmentIndex == 1 {
            setViewControllers([maps[sender.selectedSegmentIndex]], direction: .forward, animated: true)
        } else {
            setViewControllers([maps[sender.selectedSegmentIndex]], direction: .reverse, animated: true)
        }
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "Defaults_Map_Selected")
    }
    
    lazy var locationBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("outline_my_location_black_36pt_".image, for: .normal)
        view.addSubview(button)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.bottom.equalTo(-150)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        button.tapAction {[unowned self] _ in
            localRefresh()
        }
        return button
    }()
    
    lazy var locationManager: AMapLocationManager = {
        let locationManager = AMapLocationManager()
//        locationManager.delegate = self
        locationManager.distanceFilter = 200
//        locationManager.locatingWithReGeocode = true
        return locationManager
    }()
    
    func localRefresh() {
        if let loc = currentLoc {
            (viewControllers?.first as? MapVC)?.refreshLocal(loc)
        }
    }
}

extension MapPageVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
}

extension MapPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = maps.firstIndex(of: viewController), index > 0 else {
                    return nil
                }
        return maps[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = maps.firstIndex(of: viewController), index < maps.count - 1 else {
            return nil
        }
        return maps[index + 1]
    }
}


extension MapPageVC:AMapLocationManagerDelegate {
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        currentLoc = location
    }
}
