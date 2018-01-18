//
//  AddNewJornalVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 02/03/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class AddNewJornalVC: UIViewController,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate{
    @IBOutlet weak var txtDesire: DALinedTextView!
    @IBOutlet weak var lblday: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

    var datePicker: UIDatePicker!
    @IBOutlet weak var txtdate: UITextField!
    let dateFormattor = DateFormatter()
    var IsEdit : Bool! = false
    var StrDate : String! = ""
    var SelctedDate : Date!

    var tempDict = [String : Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtDesire.horizontalLineColor = UIColor.darkGray

        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(EditProfileVC.datePickerHandler(sender:)), for: .valueChanged)
        txtdate.delegate = self
        txtdate.inputView = datePicker
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "hh:mm a"
        let strtime = dateFormatterTime.string(from: Date())
        
        dateFormattor.dateFormat = "dd/MM/yyyy"
        let strdate = dateFormattor.string(from: SelctedDate)
        
        txtdate.text = strdate + " " + strtime
        txtdate.isUserInteractionEnabled = false;
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        lblday.text = dateFormatter1.string(from: SelctedDate).uppercased()
        
        if IsEdit == true {
            lbltitle.text = "Edit Journal"
            btnSave.setTitle("UPDATE NOTE",for: .normal)
            btnDelete.isHidden = false
        }
        else{
            lbltitle.text = "Add New Journal"
            btnSave.setTitle("SAVE NOTE",for: .normal)
            btnDelete.isHidden = true
        }
        if (tempDict.count > 0)
        {
           txtDesire.text = tempDict["noteText"] as! String
            txtDesire.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            let dateFormatterTime1 = DateFormatter()
            dateFormatterTime1.dateFormat = "hh:mm a"
            let strtime = dateFormatterTime1.string(from: Date())
            
            let aStr = String(format: "%@%@%@", tempDict["noteDate"] as! String, " ", strtime)
            dateFormattor.dateFormat = "yyyy-MM-dd hh:mm a"
            let dateValue = dateFormattor.date(from: aStr)
            dateFormattor.dateFormat = "dd/MM/yyyy hh:mm a"
            txtdate.text = dateFormattor.string(from: dateValue!)

        }
        txtdate.isUserInteractionEnabled = false;

    }
    
    func datePickerHandler(sender: UIDatePicker)
    {
        if txtdate.isEditing
        {
            txtdate.text = dateFormattor.string(from: sender.date)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "EEEE"
            lblday.text = dateFormatter1.string(from: sender.date).uppercased()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Button action
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this note?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("no")
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "note_id": "\(self.tempDict["journalId"] as! Int)", //"\(txtBirthdate.text!)",
                ]
            print(param)
            self.callServiceAll(Path.removeJournalEntry, param: param,methods : .post, completionHandler: { (result) in
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    self.showMessage(message: result["message"] as! String)
                }
            })

        }
        
        alertController.addAction(NoAction)
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveNotesAction(_ sender: UIButton) {
        if (txtDesire.text?.contains("Type here."))! {
            self.showMessage(message: "Please enter Journal note")
            return;
        }
        if txtDesire.text.characters.count == 0 {
            self.showMessage(message: "Please enter Journal note")
            return;
        }
        var strdate = ""
        var strtime = ""
        if (txtdate.text?.characters.count)! > 0 {
            let array = txtdate.text?.components(separatedBy: " ")
            if (array?.count)! > 0  {
                strdate = (array?[0])!
                strtime = (array?[1])!
                if (array?.count)! == 3 {
                    strtime += " "
                    strtime  += (array?[2])!
                }
            }
        }
        
        if IsEdit == true {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "note_id": "\(self.tempDict["journalId"] as! Int)", //"\(txtBirthdate.text!)",
                "note_text": txtDesire.text!,
                "note_date": strdate,
                "note_time": strtime,
                "note_timezone": self.localTimeZoneIdentifier ,
                ]
            print(param)
            
            self.callServiceAll(Path.editJournal, param: param,methods : .post, completionHandler: { (result) in
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    _ = self.navigationController?.popViewController(animated: true)

                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })

        }
        else
        {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "note_text": txtDesire.text!,
                "note_date": strdate,
                "note_time": strtime,
                "note_timezone": self.localTimeZoneIdentifier ,
                ]
            print(param)
            
            self.callServiceAll(Path.addJournal, param: param,methods : .post, completionHandler: { (result) in
                
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }
       
    }
    
    // MARK: - UITextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if txtdate.isEditing
        {
            txtdate.text = dateFormattor.string(from: Date())
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "EEEE"
            lblday.text = dateFormatter1.string(from: Date()).uppercased()
        }
    }
    
    // MARK: - UITextView delegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here..." {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        if updatedString?.characters.count == 0 {
            textView.text = "Type here..."
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        if (updatedString?.contains("Type here."))! {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
      
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
       // let updatedString = (textView.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)

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
