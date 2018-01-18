//
//  ForgotPasswordVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 14/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

      @IBOutlet weak var txtEmail: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeNavigationBarItem()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button action
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if isValidTextfield()
        {
         //   performSegue(withIdentifier: "homeviewVC", sender: self)
            let param: [String: Any] = [
                "email": txtEmail.text! ,
            ]
            print(param)
            self.callServiceAll(Path.urlForgotPswd, param: param, completionHandler: { (result) in
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    //print(result["user_details"] as! [String : Any])
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }
    }
    func isValidTextfield() -> Bool
    {
        if txtEmail.text == ""
        {
            showMessage(message: "Please enter email")
            return false
        }
        else  if !(txtEmail.text?.isValidEmail())!
        {
            showMessage(message: "Please enter valid email")
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
