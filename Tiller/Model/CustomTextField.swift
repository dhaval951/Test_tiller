//
//  CustomTextField.swift
//  TimeCard
//
//  Created by Sanjay Shah on 28/10/16.
//  Copyright © 2016 Sanjay Shah. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    //MARK:- Variables
    private let border = CALayer()
    var colorvalue : UIColor = UIColor.white

    //MARK:- Default Function Of UITextField
    override func draw(_ rect: CGRect) {
        setBorder(color: colorvalue)
        // Drawing code
    }
    
    //MARK:- Set Bottom Border To The TextField
    func setBorder(color: UIColor) {
        border.borderWidth = 1
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height - 2 , width: self.frame.width, height: 1)
        colorvalue = color
        self.layer.addSublayer(border)
        self.clipsToBounds = true
    }
    
    @IBInspectable override var borderColor: UIColor? {
        get {
            return nil
        }
        set {
            setBorder(color: newValue!)
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
}
