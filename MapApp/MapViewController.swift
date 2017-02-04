//
//  MapViewController.swift
//  MapApp
//
//  Created by ehsy-it on 2016/11/25.
//  Copyright © 2016年 ehsy-it. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class MapViewController : ViewController, MKMapViewDelegate {
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var centerx: Double?
    var centery: Double?
    var target: CLLocation!
    var span: MKCoordinateSpan = MKCoordinateSpanMake(0.0036637413717031109, 0.0026232334665792223)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.showsBuildings = true
        mapView.isZoomEnabled = true
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true //显示指南针
            mapView.showsScale = true //显示比例尺
            mapView.showsTraffic = true //显示交通
        }
        target = CLLocation(latitude: 31.2043, longitude: 121.5981)
        
        if CLLocationManager.locationServicesEnabled() {
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
            self.locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        
        let objectAnnotation = TargetPoint(c: self.target.coordinate, t: "凌阳大厦")
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.addAnnotation(objectAnnotation)
        
        self.addPloygon();
        
        
        // 获取Url --- 这个是我获取的天气预报接口，时间久了可能就会失效
        let url:URL = URL(string: "http://localhost:3000/")!
        // 转换为requset
        var request: URLRequest = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //NSURLSession 对象都由一个 NSURLSessionConfiguration 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        //NSURLSessionTask负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载，NSURLSessionTask 与 NSURLConnection 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 NSURLSession 这一公共委托者（common delegate）
        
        let task: URLSessionDataTask = session.dataTask(with: request){
            (data, response, error) -> Void in
            if error != nil {
                return
            } else {
                let json: Any = try! JSONSerialization.jsonObject(with: data!, options: [])
                if let value = (JSON)(json)["title"].string {
                    print("状态是：\(value)")
                }
                print(json)
            }
        }
        
        // 启动任务
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            
            mapView.centerCoordinate = loc.coordinate
            let region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 500, 500);
            mapView.setRegion(region, animated: true)
            
            
            self.distance.text = String(format: "%.0f", loc.distance(from: self.target))
            /*
             if distance <= 50 {
             print("50米以内")
             } else if distance <= 100 {
             print("100米以内")
             } else if distance <= 150 {
             print("150米以内")
             } else if distance <= 200 {
             print("200米以内")
             }
             */
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.span = mapView.region.span
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)){
            return nil;
        }
        
        if (annotation.isKind(of: TargetPoint.self)){
            // 首先尝试复用已存在的MKPinAnnotationView。
            //let pinView: MKPinAnnotationView!
            if let pinView: MKPinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "TargetView") as? MKPinAnnotationView {
                pinView.annotation = annotation;
                return pinView
            } else {
                let pinView:MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "TargetView")
                pinView.pinTintColor = UIColor.blue
                pinView.animatesDrop = true
                pinView.canShowCallout = true
                
                let rightButton: UIButton = UIButton(type: UIButtonType.detailDisclosure)
                // 因为没有页面跳转，所以Target和action参数设为nil。
                //[rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                rightButton.addTarget(nil, action: #selector(MapViewController.showQuestion), for: UIControlEvents.touchUpInside)
                pinView.rightCalloutAccessoryView = rightButton;
                return pinView
            }
            
        }
        
        return nil;
    }
    
    func showQuestion(){
        let frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        let questionView = QuestionView(frame: frame)
        self.view.addSubview(questionView)
        self.view.bringSubview(toFront: questionView)
    }
    
    func addPloygon() {
        let x1 = 121.5981
        let y1 = 31.2043
        //右上
        let x2 = 121.5983
        let y2 = 31.2045
        // 添加多边形覆盖物
        var coords = [CLLocationCoordinate2D]()
        coords.append(CLLocationCoordinate2DMake(y1, x1))
        coords.append(CLLocationCoordinate2DMake(y1, x2))
        coords.append(CLLocationCoordinate2DMake(y2, x2))
        coords.append(CLLocationCoordinate2DMake(y2, x1))
        
        let  polygon = MKPolygon(coordinates: &coords, count:  Int(coords.count))
        polygon.title = "宝箱"
        self.mapView.add(polygon)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.red
            
            return polygonView
        }
        return MKOverlayRenderer()
    }
}
