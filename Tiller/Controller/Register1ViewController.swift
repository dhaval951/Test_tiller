//
//  Register1ViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class Register1ViewController: UIViewController, UITextFieldDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate{

    //MARK: - Outlet
    @IBOutlet var btnGender: [UIButton]!
    @IBOutlet var btnUserType: [UIButton]!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtBirthdate: UITextField!
    @IBOutlet weak var imgprofile: UIImageView!

    var TempDict = [String : Any]()

    @IBOutlet var btnprofile: UIButton!
    // UIImagePicker
    var imagePicker = UIImagePickerController()
    var isCamera = true
    var isImagesSelected = false
    var imageName = ""
    var isFromImagePicker = false
    //MARK: - Declaration
    var datePicker: UIDatePicker!
    var fixedImaage : UIImage!
    var GenderInt = -1
    var UserTypeInt = -1

    //MARK: - controller method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeNavigationBarItem()

        datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(Register1ViewController.datePickerHandler(sender:)), for: .valueChanged)
        txtBirthdate.delegate = self
        txtBirthdate.inputView = datePicker
        
        txtFullName.delegate = self

//        btnGender[0].isSelected = true
//        btnUserType[0].isSelected = true
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
        
         fixedImaage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        isImagesSelected = true
        btnprofile.setImage(fixedImaage , for: .normal)
        imgprofile.image = fixedImaage;
        
        //imgprofile.image = fixedImaage
        //        btnprofile.setImage(imgprofile.image , for: .normal)
        
        if imageName == ""
        {
            //        imageName = "\(Timestamp).png"
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnGenderAction(_ sender: UIButton) {
        
        sender.isSelected = true
        btnGender[btnGender.index(of: sender)! ^ 1].isSelected = false
        if (btnGender[0].isSelected) {
            GenderInt = 1
        }
        else{
            GenderInt = 2
        }
    
    }
    
    @IBAction func btnUserTypeAction(_ sender: UIButton) {
        
        sender.isSelected = true
        btnUserType[btnUserType.index(of: sender)! ^ 1].isSelected = false
        if (btnUserType[0].isSelected) {
            UserTypeInt = 2
        }
        else{
            UserTypeInt = 1
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if isValidTextfield()
        {
            performSegue(withIdentifier: "segueNext", sender: self)
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
        // MARK: - UITextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == txtFullName {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 120
        }
        return true
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueNext"
        {
            let destination = segue.destination as! Register2ViewController
            destination.imgprofile = imgprofile;
            destination.isImagesSelected = isImagesSelected;
            
            TempDict = [
                "fullname": "\(txtFullName.text!)",
                "dob": "\(txtBirthdate.text!)",
                "usertype": UserTypeInt,
                "gender": GenderInt,
            ]
            destination.PreviousDict = TempDict
        }
    }
    func isValidTextfield() -> Bool
    {
        if txtFullName.text == ""
        { 
            showMessage(message: "Please enter full name")
            return false
        }
        else if txtBirthdate.text == ""
        {
            showMessage(message: "Please select birthdate")
            return false
        }
        else if GenderInt < 0
        {
            showMessage(message: "Please select gender")
            return false
        }
        else if UserTypeInt < 0
        {
            showMessage(message: "Please select user type")
            return false
        }
        return true
    }


}
