//
//  LoginViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeNavigationBarItem()
        // Do any additional setup after loading the view.
 //        txtEmail.text = "dhavalbhadania951@gmail.com";
//        txtPassword.text = "123456";
//        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if UserDefaults.standard.value(forKey: "userid") != nil {
            if self.UserType == 2 //Parent then go to Child List HOme page
            {
                self.performSegue(withIdentifier: "ChildVC", sender: self)
            }
            else if self.UserType == 1 //Child then go to main HOme page
            {
                self.performSegue(withIdentifier: "homeviewVC", sender: self)
            }
        }
        else {
//           performSegue(withIdentifier: "LoginViewController", sender: self)
        }

        self.removeNavigationBarItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button action
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        if isValidTextfield()
        {
            let param: [String: Any] = [
                "email": txtEmail.text! ,
                "password": txtPassword.text!,
                "device_type": "2" ,
                "device_token": appDelegate.deviceToken
            ]
            print(param)
            print(Path.urlLogin)

            self.callServiceAll(Path.urlLogin, param: param, completionHandler: { (result) in
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    print(result["userDetail"] as! [String : Any])
                    
                    UserDefaults.standard.set(result["userDetail"] as! [String : Any], forKey: "UserDetail")
                    
                    UserDefaults.standard.set(((result["userDetail"] as! [String : Any])["userid"] as! Int), forKey: "userid")
                    
                    UserDefaults.standard.set(((result["userDetail"] as! [String : Any])["fullname"] as! String), forKey: "user_name")
                    UserDefaults.standard.set(((result["userDetail"] as! [String : Any])["profile_image"] as! String), forKey: "user_image")
                    let userName  =  String(format: "tiller_%@", UserDefaults.standard.string(forKey: "userid")!.lowercased())
                    UserDefaults.standard.set(userName, forKey: "chatusername")
                    UserDefaults.standard.set(userName, forKey: "chatpassword")
                    
                    _ = self.appDelegate.connect()
                    if self.UserType == 2 //Parent then go to Child List HOme page
                    {
                        self.performSegue(withIdentifier: "ChildVC", sender: self)
                    }
                    else if self.UserType == 1 //Child then go to main HOme page
                    {
                        self.performSegue(withIdentifier: "homeviewVC", sender: self)
                    }
                    
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }
    }
    
    
    
    @IBAction func btnForgotPasswordAction(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoforgotpassword", sender: self)
    }
    
    func isValidTextfield() -> Bool
    {
        if txtEmail.text == ""
        {
            showMessage(message: "Please enter register email")
            return false
        }
        else  if !(txtEmail.text?.isValidEmail())!
        {
            showMessage(message: "Please enter valid email")
            return false
        }
        else if txtPassword.text == ""
        {
            showMessage(message: "Please enter password")
            return false
        }
        else if (txtPassword.text?.characters.count)! < 6
        {
            showMessage(message: "Password should be at least 6 characters long")
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
