//
//  Register2ViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GooglePlaces
import GoogleMaps

class Register2ViewController: UIViewController,GMSAutocompleteViewControllerDelegate,UITextFieldDelegate {
    /**
     * Called when a non-retryable error occurred when retrieving autocomplete predictions or place
     * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
     * retrying the operation.
     * <p>
     * Only the following values of |GMSPlacesErrorCode| are retryable:
     * <ul>
     * <li>kGMSPlacesNetworkError
     * <li>kGMSPlacesServerError
     * <li>kGMSPlacesInternalError
     * </ul>
     * All other error codes are non-retryable.
     * @param viewController The |GMSAutocompleteViewController| that generated the event.
     * @param error The |NSError| that was returned.
     */
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }


    //MARK: - Outlet
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtContactNumber: CustomTextField!
    @IBOutlet weak var imgprofile: UIImageView!
    var isImagesSelected = false
   
    //Location
    var placePicker: GMSPlacePicker?
    
     var PreviousDict = [String : Any]()
    //MARK: - Declaration
    
    //MARK: - controller method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeNavigationBarItem()
        txtAddress.delegate = self
        txtEmail.delegate = self
        txtConfirmPassword.delegate = self
        txtPassword.delegate = self
        txtContactNumber.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button action
    @IBAction func btnTermsAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueFromRegisterToOpenPdfFile", sender: nil)
    }
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        
        if isValidTextFeild() {
            if isImagesSelected {
                let param: [String: Any] = [
                    "email": txtEmail.text! ,
                    "password": txtConfirmPassword.text!,
                    "address": txtAddress.text!,
                    "contactno": txtContactNumber.text!,
                    "device_type": "2",
                    "device_token": appDelegate.deviceToken,
                    "fullname": PreviousDict["fullname"] as! String ,
                    "dob":  PreviousDict["dob"] as! String,
                    "usertype":  PreviousDict["usertype"] as! Int,
                    "gender":  PreviousDict["gender"] as! Int
                ]
                print(param)
                self.callServiceAll(Path.urlRegister, param: param,  dataKey: ["profile_image"], data: [UIImagePNGRepresentation(imgprofile.image!)!], completionHandler: { (result) in
                    
                    if result["status"] as! Bool
                    {
                        self.showMessage(message: result["message"] as! String)
                        print(result["userDetail"] as! [String : Any])
                        
                        UserDefaults.standard.set(result["userDetail"] as! [String : Any], forKey: "UserDetail")
                        UserDefaults.standard.set(((result["userDetail"] as! [String : Any])["userid"] as! Int), forKey: "userid")
                        _ = self.appDelegate.connect()
                        if self.UserType == 2 //Parent then go to Child List HOme page
                        {
                            self.performSegue(withIdentifier: "ChildVC", sender: self)
                        } else if self.UserType == 1 //Child then go to main HOme page
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
            else{
                let param: [String: Any] = [
                    "email": txtEmail.text! ,
                    "password": txtConfirmPassword.text!,
                    "address": txtAddress.text!,
                    "contactno": txtContactNumber.text!,
                    "device_type": "2",
                    "device_token": appDelegate.deviceToken,
                    "fullname": PreviousDict["fullname"] as! String ,
                    "dob":  PreviousDict["dob"] as! String,
                    "usertype":  PreviousDict["usertype"] as! Int,
                    "gender":  PreviousDict["gender"] as! Int
                ]
                print(param)
                self.callServiceAll(Path.urlRegister, param: param, completionHandler: { (result) in
                    
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
                        } else if self.UserType == 1 //Child then go to main HOme page
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
    }
      // MARK: - UITextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if txtAddress == textField {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
        }
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == txtContactNumber {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 12
        }
        return true
    }
    func isValidTextFeild() -> Bool
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
        else if txtAddress.text == ""
        {
            showMessage(message:"Please enter address")
            return false
        }
        else if txtContactNumber.text == ""
        {
            showMessage(message: "Please enter contact number")
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
        else if txtConfirmPassword.text != txtPassword.text
        {
            showMessage(message: "Password and Confirm password does not match")
            return false
        }
       
        return true
    }
    // MARK: - GMSAutocompleteViewController Delegate.
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtAddress.text = place.formattedAddress!
       // self.latitude = "\(place.coordinate.latitude)"
      //  self.longitude = "\(place.coordinate.longitude)"
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromRegisterToOpenPdfFile" {
            let destController = segue.destination as! OpenPdfFileVC
            destController.strFileName = "TermsAndCondition"
            destController.strTitle = "Terms & Conditions"
        }
    }
}
