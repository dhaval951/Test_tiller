//
//  EditProfileVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 23/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//
import Foundation
import UIKit
import GooglePlacePicker
import GooglePlaces
import GoogleMaps

class EditProfileVC: UIViewController, UITextFieldDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource ,GMSAutocompleteViewControllerDelegate {
  
    var userDefault = UserDefaults.standard

    var TitleAry = ["EMAIL","FULL NAME", "CONTACT", "DOB", "LOCATION", "GENDER", "USER TYPE"]
    
    var VlaueAry = [[String: Any]]()
    var TempDict = [String: Any]()
    var StrFullname :String = ""
    var Straddress:String = ""
    var StrContactNO:String = ""
    var StrGender :String = ""
    var StrDOB :String = ""
    var StrUsertType :String = ""

    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    
    // UIImagePicker
    var imagePicker = UIImagePickerController()
    var isCamera = true
    var isImagesSelected = false
    var isLocationSelected = false

    var imageName = ""
    var isFromImagePicker = false

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtBirthdate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtUserType: UITextField!
    var datePicker: UIDatePicker!
    var pickerView = UIPickerView()
    var pickerData = ["Male", "Female"]
    var StrSelction = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isImagesSelected = false;
        datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(EditProfileVC.datePickerHandler(sender:)), for: .valueChanged)
        txtBirthdate.delegate = self
        txtBirthdate.inputView = datePicker
        
        self.navigationController?.isNavigationBarHidden = true
      
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.lightGray
            txtGender.inputView = pickerView
            txtUserType.inputView = pickerView

    }
    override func viewDidAppear(_ animated: Bool) {
        
        txtEmail.textColor = UIColor.lightGray
        txtUserType.textColor = UIColor.lightGray
        
        if (TempDict.count != 0 && isImagesSelected == false && isLocationSelected == false) {
            var currentSport = TempDict
            if (currentSport["profile_image"] as! String) != "" {
                self.imgProfile.setImage(url:currentSport["profile_image"] as! String, placeHolderImage: "profile_default_img")
                
                self.imgProfile.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                self.imgProfile.borderWidth = 2
                isImagesSelected = true
            }

            txtEmail.text = (currentSport["email"] as! String)
            txtEmail.textColor = UIColor.lightGray
            txtUserType.textColor = UIColor.lightGray
            txtFullName.text = (currentSport["fullname"] as! String)
            txtContact.text =  "\((currentSport["contactno"] as! Int64))"
            txtBirthdate.text = (currentSport["dob"] as! String)
            txtLocation.text = (currentSport["address"] as! String)

            var StrGender : String = ""
            if ((currentSport["gender"] as! Int) == 1) {
                StrGender = "Male"
            }else {
                StrGender = "Female"
            }
            txtGender.text = StrGender;
            
            var Str : String = ""
            if ((currentSport["usertype"] as! Int) == 2) {
                Str = "Parent"
            }else{
                Str = "Child"
            }
            txtUserType.text = Str
        }
    }
    func datePickerHandler(sender: UIDatePicker)
    {
        if txtBirthdate.isEditing
        {
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "dd/MM/yyyy"
            txtBirthdate.text = dateFormattor.string(from: sender.date)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Textfiend delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if txtBirthdate.isEditing
        {
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "dd/MM/yyyy"
            txtBirthdate.text = dateFormattor.string(from: Date())
        }
        if txtGender.isEditing
        {
             pickerData = ["Male", "Female"]
            pickerView.delegate = self
            pickerView.dataSource = self
            
            pickerView.backgroundColor = UIColor.lightGray
            txtUserType.inputView = pickerView
            StrSelction = "Gender"
            pickerView.reloadAllComponents()
        }
        if txtUserType.isEditing
        {
             pickerData = ["Parent", "Child"]
            pickerView.delegate = self
            pickerView.dataSource = self
            
            pickerView.backgroundColor = UIColor.lightGray
            txtUserType.inputView = pickerView
            StrSelction = "UserType"

            pickerView.reloadAllComponents()

        }
        if txtLocation == textField {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
        }
    }

    // MARK: - Button action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        self.CallWebservice()
//        self.perform(#selector(EditProfileVC.CallWebservice), with: nil, afterDelay: 3.0)

    }

    func CallWebservice()  {
        print("Call webservice here!!!")
        //"\([UserDefaults.standard]["userid"] as! Int)"
        if !isValidTextFeild() {
            return;
        }
        
        
        //================
        if isImagesSelected {
    
            
            var Gender : Int = -1
            StrGender = txtGender.text!
            if (StrGender ==  "Male") {
                Gender = 1
            }else {
                Gender = 2
            }
    
            let param: [String: Any] = [
                "user_id": self.userId ,
                "fullname": txtFullName.text!,
                "address":txtLocation.text!,
                "contactno": txtContact.text!,
                "gender":  Gender,
                "dob":  txtBirthdate.text!
            ]
            
            print(param)

            
            self.callServiceAll(Path.urlEditProfile, param: param,  dataKey: ["profile_image"], data: [UIImagePNGRepresentation(imgProfile.image!)!],methods : .post, completionHandler: { (result) in
                
                if result["status"] as! Bool
                {
                    
                    UserDefaults.standard.set(((result["userDetail"] as! [String : Any])["profile_image"] as! String), forKey: "user_image")

                    self.showMessage(message: result["message"] as! String)
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }

            })
            
        }
        else{
            
            var Gender : Int = -1
            StrGender = txtGender.text!
            if (StrGender ==  "Male") {
                Gender = 1
            }else {
                Gender = 2
            }
     
            let param: [String: Any] = [
                "user_id": self.userId ,
                "fullname": txtFullName.text!,
                "address":txtLocation.text!,
                "contactno": txtContact.text!,
                "gender":  Gender,
                "dob":  txtBirthdate.text!,
            ]
            
            print(param)
            self.callServiceAll(Path.urlEditProfile, param: param,methods : .post, completionHandler: { (result) in
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }

    }
    func isValidTextFeild() -> Bool
    {
        if txtEmail.text == ""
        {
            showMessage(message: "Please enter email")
            return false
        }
        else if txtLocation.text == ""
        {
            showMessage(message:"Please enter address")
            return false
        }
        else if txtContact.text == ""
        {
            showMessage(message: "Please enter conatct number")
            return false
        }
        else if txtFullName.text == ""
        {
            showMessage(message: "Please enter full name")
            return false
        }
        else if txtGender.text == ""
        {
            showMessage(message: "Please select gender")
            return false
        }
        else if txtUserType.text == ""
        {
            showMessage(message: "Please select user type")
            return false
        }
        return true
    }

    // MARK: - Button action
    @IBAction func btnProfilection(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: "Take image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.delegate = self
                imagePicker.isEditing = true
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                self.isFromImagePicker = false
            }
            else
            {
                self.showMessage(message: ToastMsg.cameraNotAvailabel)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action) in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            imagePicker.isEditing = true
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            self.isFromImagePicker = false
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imageViewHeight(image: UIImage) -> CGFloat
    {
        let width = image.size.width
        let height = image.size.height
        
        let viewWidth = view.frame.size.width
        
        let ratio = viewWidth * 100 / width
        let newHight = (height * ratio) / 100
        return newHight
    }
    // MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage!
        if isCamera
        {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }
        else
        {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }

       let fixedImaage = UIImage(cgImage: image.cgImage!, scale: image .scale, orientation: image.imageOrientation)
        isImagesSelected = true
        btnProfile.setImage(fixedImaage , for: .normal)
        imgProfile.image = fixedImaage;
        
        //imgprofile.image = fixedImaage
        //        btnprofile.setImage(imgprofile.image , for: .normal)
        
        if imageName == ""
        {
            //        imageName = "\(Timestamp).png"
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: - UITextField delegate
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == txtContact {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 12
        }
        return true
    }

      // MARK: - UIPickerView delegate
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  StrSelction == "Gender" {
            txtGender.text = pickerData[row]
        }
        else if  StrSelction == "UserType"
        {
            txtUserType.text = pickerData[row]
        }
    }
    
    // MARK: - GMSAutocompleteViewController Delegate.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtLocation.text = place.formattedAddress!
        // self.latitude = "\(place.coordinate.latitude)"
        //  self.longitude = "\(place.coordinate.longitude)"
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        isLocationSelected = true
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
    

    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
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

class EditProfileCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var txtValue: UITextField!

    
    
}
