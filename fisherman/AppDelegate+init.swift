//
//  AppDelegate+init.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/15.
//

import Foundation
import AMapFoundationKit

extension AppDelegate {
    
    func initSDKs(){
        initAMap()
    }
    
    func initAMap() {
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = "4d7ca58e464726a3219fbacba6721808"
    }
}


