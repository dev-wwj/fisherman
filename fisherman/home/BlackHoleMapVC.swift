//
//  BlackHoleMapVC.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/18.
//

import UIKit
import AMapSearchKit
import MAMapKit.MAPointAnnotation

class BlackHoleMapVC: MapVC {
    
    var searchHandle = POISearchHandle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        _ = listVC
        searchHandle.addDelegate(self)
    }
    
    override func refreshLocal(_ local: CLLocation) {
        super.refreshLocal(local)
    }

    lazy var listVC: BlackHoleListVC = {
        let vc = BlackHoleListVC()
        vc.searchHandle = searchHandle
        vc.superVC = self
        return vc
    }()

}

// -----MAMapViewDelegate------
extension BlackHoleMapVC {
    override func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction == true, mapView.zoomLevel > 10 {
            searchHandle.request(mapView.region)
        }
    }
    
    override func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        if wasUserAction == true, mapView.zoomLevel > 10 {
            searchHandle.request(mapView.region)
        }
    }
    
    override func mapInitComplete(_ mapView: MAMapView!) {
        searchHandle.request(mapView.region)
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if let overlay = overlay as? MAPolyline {
            let polylineRenderer = MAPolylineRenderer(polyline: overlay)
            polylineRenderer?.lineWidth = 8
            polylineRenderer?.strokeColor =  .red
            polylineRenderer?.lineJoinType = kMALineJoinRound
            polylineRenderer?.lineCapType = kMALineCapRound
            return polylineRenderer
        }
        return nil
    }
}

extension BlackHoleMapVC: POISearchDelegate {
    func search(handle: POISearchHandle, new value: [AMapPOI]) {
        value.forEach { poi in
            let pointAnnotation = MAPointAnnotation()
            pointAnnotation.coordinate = poi.coordinate
            pointAnnotation.title = poi.name
            pointAnnotation.subtitle = poi.description
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
}
