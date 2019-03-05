//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by 윤성호 on 05/03/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {
    
    var param : NSDictionary!   // 전달되는 데이터를 받을 변수
    
    @IBOutlet var map: MKMapView!   // map view
    
    override func viewDidLoad() {
        
        // 네비게이션 아이템의 제목을 수정
        self.navigationItem.title = self.param["상영관명"] as? String
        
        // 맵에 표시할 위도, 경도를 Double 타입으로 변환하여 가져오기
        let lat = (param["위도"] as! NSString).doubleValue
        let lng = (param["경도"] as! NSString).doubleValue
        
        // 위도, 경도를 2D 위치 정보 객체 정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        // 지도에 표현될 거리 : 값의 단위는 m
        let regionRadius : CLLocationDistance = 100
        
        // 거리를 반영한 지역 정보를 조합한 지도 데이터를 생성
        let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        // map 설정
        map.setRegion(coordinateRegion, animated: true)
        
        // map에 해당 지역 포인트 지정
        let annotation = MKPointAnnotation()
        annotation.title = self.param["상영관명"] as? String
        annotation.coordinate = location
        map.addAnnotation(annotation)
        
    }
}
