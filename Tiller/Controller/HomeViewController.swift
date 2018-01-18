//
//  HomeViewController.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 13/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {
    var myProfileViewController: UIViewController!
    var celebratewithmeVC :UIViewController!
    @IBOutlet var Pop_view: UIView!
    @IBOutlet var Pop_txtemail: UITextField!
    @IBOutlet var Pop_txtPhone: UITextField!
    var tempData = [String: Any]()
    var arrTribe = [[String: Any]]()
    var tempDict = [String : Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        Pop_view.backgroundColor = UIColor.clear
        Pop_view.isHidden = true
        
        Pop_txtemail.delegate = self
        Pop_txtPhone.delegate = self

        
        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        tap.delegate = self
        Pop_view.addGestureRecognizer(tap)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.Pop_txtemail.text = ""
        self.Pop_txtPhone.text = ""
    }
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        Pop_view.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - ValidTextFeild action
    func isValidTextFeild() -> Bool
    {
        if Pop_txtemail.text == "" && Pop_txtPhone.text == ""
        {
            showMessage(message: "Please enter email or phone number")
            return false
        }
        if (Pop_txtemail.text?.characters.count)! > 0 && !(Pop_txtemail.text?.isValidEmail())!
        {
            showMessage(message: "Please enter valid email")
            return false
        }
        return true
    }
    // MARK: - UITextField delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == Pop_txtPhone {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 12
        }
        return true
    }
    // MARK: - Button action
    @IBAction func btnViewProfileAction(_ sender: UIButton) {
        if self.UserType == 2 {
            self.appDelegate.selectedMenuIndex = 0
        }
        else if self.UserType == 1{
            self.appDelegate.selectedMenuIndex = 1
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MyProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyProfileViewController")
        self.myProfileViewController = UINavigationController(rootViewController: MyProfileViewController)
        self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)
        
    }
    
    // MARK: - Button action
    @IBAction func btnCelebrateWithMeAction(_ sender: UIButton) {
      
        if self.UserType == 2 {
            self.appDelegate.selectedMenuIndex = 5
        }
        else if self.UserType == 1{
            self.appDelegate.selectedMenuIndex = 6
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let CelebrateWithMeVC = mainStoryboard.instantiateViewController(withIdentifier: "CelebrateWithMeVC")
        self.celebratewithmeVC = UINavigationController(rootViewController: CelebrateWithMeVC)
        self.slideMenuController()?.changeMainViewController(self.celebratewithmeVC, close: true)

    }
    
    @IBAction func btnMyTribeAction(_ sender: UIButton) {
        if self.UserType == 2 {
            self.appDelegate.selectedMenuIndex = 1
        }
        else if self.UserType == 1{
            self.appDelegate.selectedMenuIndex = 2
        }
        self.performSegue(withIdentifier: "MyTribeViewController", sender: self)
        
    }
    
    @IBAction func btnAddNewJournalAction(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "MyJournal", sender: self)
        self.performSegue(withIdentifier: "AddNewJornalVC", sender: self)

    }
    
    @IBAction func btnHelpRequestAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateHelpRequestVC", sender: self)

    }
    
    @IBAction func btnAddMytribeAction(_ sender: UIButton) {
     //   self.performSegue(withIdentifier: "Mytribe", sender: self)
        self.view.bringSubview(toFront: self.Pop_view)
        Pop_view.isHidden = false
    }
    
    @IBAction func btnSeacrhPopOverAction(_ sender: UIButton) {
        
        if isValidTextFeild() {
            print("Add My tribe Calling here!!!")
            Pop_view.isHidden = true
                   
            let param: [String: Any] = [
                "user_id": self.userId ,
                "email": Pop_txtemail.text! ,
                "contactno": Pop_txtPhone.text!
            ]
            print(param)
            self.callServiceAll(Path.searchTribeMember, param: param,methods : .get, completionHandler: { (result) in
                self.Pop_txtemail.text = ""
                self.Pop_txtPhone.text = ""
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                   // self.tempData = result.getArray(key: "list")
                    self.arrTribe = result.getArrayofDictionary(key: "list")//data["data"] as! [[String: Any]]

                   //  self.arrTribe = result["list"] as! [String: Any]
                    self.performSegue(withIdentifier: "SearchedTribueVC", sender: self)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "MyProfile"
        {
            _ = segue.destination as! MyProfileViewController
//            destination.TempDict = TempDict;
        }
        
        if segue.identifier == "CreateHelpRequestVC"
        {
            _ = segue.destination as! CreateHelpRequestVC
//            destination.arrTribe = self.arrTribe ;
        }
        
        if segue.identifier == "CelebrateWithMeVC"
        {
            let destination = segue.destination as! CelebrateWithMeVC
          //  destination.arrTribe = self.arrTribe ;
        }
        if segue.identifier == "SearchedTribueVC"
        {
            let destination = segue.destination as! SearchedTribueVC
            destination.arrTribe = self.arrTribe ;
        }
        
        if segue.identifier == "AddNewJornalVC"
        {
            let destination = segue.destination as! AddNewJornalVC
            let dateFormattor = DateFormatter()
            self.tempDict.removeAll()
            destination.IsEdit = false
            dateFormattor.dateFormat = "dd/MM/yyyy hh:mm a"
            destination.StrDate = dateFormattor.string(from: NSDate() as Date)
            destination.SelctedDate = NSDate() as Date
            if (tempDict.count > 0){
                destination.tempDict = tempDict
            }
        }
    
    }

}
