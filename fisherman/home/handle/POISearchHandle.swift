//
//  POISearchHandle.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/25.
//

import Foundation
import AMapSearchKit
import MAMapKit.MAPointAnnotation

protocol POISearchDelegate: NSObjectProtocol {
    
    func search(handle:POISearchHandle, new value:[AMapPOI])
}

class POISearchHandle:NSObject {
    
    private var delegates =  NSHashTable<AnyObject>.weakObjects()
    
    func addDelegate(_ delegate: POISearchDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: POISearchDelegate) {
        delegates.remove(delegate)
    }
    
    /// 搜索结果
    var results = [AMapPOI]()
    
    lazy var searchAPI: AMapSearchAPI? = {
        let search = AMapSearchAPI()
        search?.delegate = self
        return search
    }()
    
    func request(_ region: MACoordinateRegion) {
        let polygon = AMapGeoPolygon(points: region.rectPoints())
        let request = AMapPOIPolygonSearchRequest()
        request.polygon = polygon
        //        let request = AMapPOIAroundSearchRequest()
        //        request.location = AMapGeoPoint.location(withLatitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        request.keywords = "钓鱼|路亚|垂钓"
        request.types = "体育休闲服务|休闲场所|垂钓园"
        searchAPI?.aMapPOIPolygonSearch(request)
    }
}

extension POISearchHandle: AMapSearchDelegate {
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        var newPois = [AMapPOI]()
        response.pois.forEach { poi in
            if results.contains(where: { _poi in
                _poi.uid == poi.uid
            }) {
               return
            }
            newPois.append(poi)
        }
        results += newPois
        delegates.allObjects.forEach {
            ($0 as? POISearchDelegate)?.search(handle: self, new: newPois)
        }

    }
}

extension AMapPOI {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude)
    }
}

extension MACoordinateRegion {
    
    func rectPoints() -> [AMapGeoPoint] {
        return [AMapGeoPoint.location(withLatitude: center.latitude - span.latitudeDelta/2, longitude: center.longitude - span.longitudeDelta/2),
                AMapGeoPoint.location(withLatitude: center.latitude + span.latitudeDelta/2, longitude: center.longitude + span.longitudeDelta/2),]
    }
    
}
