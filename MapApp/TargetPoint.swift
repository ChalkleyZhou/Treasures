//
//  TargetPoint.swift
//  MapApp
//
//  Created by ehsy-it on 2016/11/25.
//  Copyright © 2016年 ehsy-it. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TargetPoint: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(c: CLLocationCoordinate2D , t: String){
        self.coordinate = c
        self.title = t
    }
    
}
