//
//  ChangePasswordVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 24/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    var userDefault = UserDefaults.standard

    @IBOutlet var btnUpdate: UIButton!

    @IBOutlet weak var txtoldP: UITextField!
    @IBOutlet weak var txtNewP: UITextField!
    @IBOutlet weak var txtRepeatedNP: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Menu helper method
    override func setNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    override func removeNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }

    @IBAction func btnUpdateAction(_ sender: UIButton)
    {
        if isValidTextFeild() {
         
            let param: [String: Any] = [
                "user_id": self.userId ,
                "old_password": txtoldP.text! ,
                "new_password": txtRepeatedNP.text!,
                ]
            print(param)
            self.callServiceAll(Path.urlChangePswd, param: param, completionHandler: { (result) in
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    self.navigationController?.popViewController(animated: true)
                }else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
            
        }
    }
    
    func isValidTextFeild() -> Bool
    {
        if txtoldP.text == ""
        {
            showMessage(message: "Please enter old password")
            return false
        }
        else if txtNewP.text == ""
        {
            showMessage(message:"Please enter new password")
            return false
        }
        else if txtRepeatedNP.text == ""
        {
            showMessage(message: "Please enter repeat new password")
            return false
        }
        else if (txtNewP.text?.characters.count)! < 6
        {
            showMessage(message: "Password should be at least 6 characters long.")
            return false
        }
        else if txtNewP.text != txtRepeatedNP.text
        {
            showMessage(message: "Password and Confirm password does not match")
            return false
        }
       
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
