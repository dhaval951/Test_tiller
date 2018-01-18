//
//  PickerCustomTextField.swift
//  DrillApp
//
//  Created by Tarungiri Gosai on 04/01/17.
//  Copyright © 2017 Tarungiri Gosai. All rights reserved.
//

import UIKit

class PickerCustomTextField: UITextField,UIPickerViewDelegate {

    let pickerController = UIPickerView()
    
    override func draw(_ rect: CGRect) {
        
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode.always
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "arrowDownBlack"))
        imageView.frame = CGRect(x: self.frame.size.height/2-7.5, y: self.frame.size.height/2-7.5, width: 15 , height: 15)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.rightViewMode = UITextFieldViewMode.always
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        view.addSubview(imageView)
        self.rightView = view

    }
    
    //MARK:- Disable Cut Copy Paste In Picker TextField
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.delete(_:)) || action == #selector(UIResponderStandardEditActions.select(_:))  || action == #selector(UIResponderStandardEditActions.selectAll(_: )) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}
