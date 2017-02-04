//
//  QuestionView.swift
//  MapApp
//
//  Created by 周晶磊 on 17/2/4.
//  Copyright © 2017年 ehsy-it. All rights reserved.
//

import UIKit

class QuestionView : UIView{
    
    @IBOutlet var contentView: UIView!
    @IBAction func cancelBtn(_ sender: Any) {
        self.removeFromSuperview();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loadView()
        
    }
    
    private func getXibName() -> String {
        let className = NSStringFromClass(self.classForCoder)
        let nameArray = className.components(separatedBy: ".")
        var xibName = nameArray[0]
        if nameArray.count == 2 {
            xibName = nameArray[1]
        }
        return xibName
    }
    
    func loadView() {
        if self.contentView != nil {
            return
        }
        self.contentView = self.loadViewWithNibName(fileName: self.getXibName(), owner: self)
        self.contentView.frame = UIScreen.main.bounds
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)
    }
    
    private func loadViewWithNibName(fileName: String, owner: AnyObject) -> UIView {
        let nibs = Bundle.main.loadNibNamed(fileName, owner: owner, options: nil)
        return nibs![0] as! UIView
    }
}
