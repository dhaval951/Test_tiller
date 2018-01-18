//
//  DIYCalendarCell.swift
//  SwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit
class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        self.circleImageView.isHidden = true

        let selectionLayer = CAShapeLayer()
//        selectionLayer.fillColor = UIColor.red.cgColor
        selectionLayer.fillColor = UIColor.clear.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.white
        self.backgroundView = view;
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.circleImageView.frame = self.frame(forAlignmentRect: CGRect(x: self.contentView.bounds.origin.x + 1, y: self.contentView.bounds.origin.y+1, width: self.contentView.bounds.width - 5, height: self.contentView.bounds.height - 3))

        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 0.5)
        self.selectionLayer.frame = self.contentView.bounds.insetBy(dx: -1, dy: 0)
    }
    
}
