//
//  MapVC.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/13.
//

import Foundation
import UIKit
import MAMapKit
import AMapFoundationKit


class MapVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        _ = mapView
    }
    
    internal lazy var mapView: MAMapView = {
        let mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 16
        return mapView
    }()
    
    func refreshLocal(_ local: CLLocation){
        mapView.setCenter(local.coordinate, animated: true)
    }
}

extension MapVC: MAMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        
    }
    
  
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        
    }
    
    func mapViewRegionChanged(_ mapView: MAMapView!) {
      
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction == true {
            print("region-- \(mapView.region)")
            print("maprect-- \(mapView.visibleMapRect)")
        }
    }
    
    
    func mapInitComplete(_ mapView: MAMapView!) {
        print("region-- \(mapView.region)")
        print("maprect-- \(mapView.visibleMapRect)")
        
        
    }
   
    
}
