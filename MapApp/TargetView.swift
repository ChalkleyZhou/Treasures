//
//  TargetView.swift
//  MapApp
//
//  Created by 周晶磊 on 17/2/4.
//  Copyright © 2017年 ehsy-it. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TargetView: MKAnnotationView {
    public override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        var myFrame:CGRect = self.frame;
        myFrame.size.width = 40;
        myFrame.size.height = 40;
        self.frame = myFrame;
        
        self.backgroundColor = UIColor.blue;
        self.isOpaque = false;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
