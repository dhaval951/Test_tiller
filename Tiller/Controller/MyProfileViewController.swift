//
//  MyProfileViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//
import Foundation
import UIKit

class MyProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    var userDefault = UserDefaults.standard

    var TitleAry = ["EMAIL", "NAME", "CONTACT NO", "DOB", "LOCATION", "GENDER", "USER TYPE"]
    
    var VlaueAry = [[String: Any]]()
    var TempDict = [String: Any]()
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var imgProfile: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgScrollView: ImageScrollView!
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var imgTimeCardZoom: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.tableFooterView = UIView()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.estimatedRowHeight = 100
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CallWebservice()
        self.setNavigationBarItem()

        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.ProfilePicZoomTap(_:)))
        tap.delegate = self
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tap)
    }
    func ProfilePicZoomTap(_ sender: UITapGestureRecognizer) {
        if imgTimeCardZoom.image != nil {
            if imgTimeCardZoom.image == UIImage(named: "profile_default_img") {
                return
            }
            zoomView.isHidden = false
            imgScrollView.display(image: imgTimeCardZoom.image!)
        }
    }
    
    func CallWebservice()  {
    
        let param: [String: Any] = [
            "user_id": self.userId ,
            ]
        print(param)
        self.callServiceAll(Path.urlGetProfile, param: param,methods : .get, completionHandler: { (result) in
            
            print(result)
            if result["status"] as! Bool
            {
               // self.showMessage(message: result["message"] as! String)
                print(result["userDetail"] as! [String : Any])
                self.TempDict = result.getDictionary(key: "userDetail")
                self.tableView.reloadData()
            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as? MyProfileCell
        cell?.lblTitle.text = TitleAry[indexPath.row]
        
        if (TempDict.count != 0) {
            var currentSport = TempDict
            if (currentSport["profile_image"] as! String) != "" {
                self.imgProfile.setImage(url:currentSport["profile_image"] as! String, placeHolderImage: "profile_default_img")
                self.imgTimeCardZoom.setImage(url:currentSport["profile_image"] as! String, placeHolderImage: "profile_default_img")
            }
            else{
                self.imgProfile.setImage(url:currentSport["profile_image"] as! String, placeHolderImage: "profile_default_img")
                self.imgTimeCardZoom.setImage(url:currentSport["profile_image"] as! String, placeHolderImage: "profile_default_img")

            }
            
            //Last time Chat
//            if appDelegate.imgChat != nil {
//                self.imgProfile.image = appDelegate.imgChat
//            }
        
           

            self.imgProfile.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            self.imgProfile.borderWidth = 2
            if indexPath.row == 0
            {
                cell?.lblValue.text = (currentSport["email"] as! String)
            }
            if indexPath.row == 1
            {
                cell?.lblValue.text = (currentSport["fullname"] as! String)
            }
            if indexPath.row == 2
            {
              
                cell?.lblValue.text = "\((currentSport["contactno"] as! Int64))"

            }
            if indexPath.row == 3
            {
                cell?.lblValue.text = (currentSport["dob"] as! String)
            }
            if indexPath.row == 4
            {
                cell?.lblValue.text = (currentSport["address"] as! String)
            }
            
            if indexPath.row == 5
            {
                var Str : String = ""
                if ((currentSport["gender"] as! Int) == 1) {
                    Str = "Male"
                }else {
                    Str = "Female"
                }
                cell?.lblValue.text = Str
            }
            if indexPath.row == 6
            {
                var Str : String = ""
                if ((currentSport["usertype"] as! Int) == 2) {
                    Str = "Parent"
                }
                else
                {
                    Str = "Child"
                }
                cell?.lblValue.text = Str
            }

        }
    cell!.selectionStyle = .none
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // MARK: - Button action
    @IBAction func btnEditAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editProfile", sender: self)
        return;
//        let actionSheet = UIAlertController(title: "Profile Edit", message: nil, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
//            self.performSegue(withIdentifier: "editProfile", sender: self)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//
//        }))
//        present(actionSheet, animated: true, completion: nil)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editProfile"
        {
            let destination = segue.destination as! EditProfileVC
            destination.TempDict = TempDict;
      
        }
    }
    // MARK: - Button Action
    @IBAction func imgTimeCardZoomAction(_ sender: UIButton) {
        //imgTimeCardZoom.image = imgTimeCard.image
//        if imgTimeCardZoom.image != nil {
//            zoomView.isHidden = false
//            imgScrollView.display(image: imgTimeCardZoom.image!)
//        }
    }
    @IBAction func closeAction(_ sender: UIButton) {
        zoomView.isHidden = true
    }
}




class MyProfileCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblValue: UILabel!
    
    
    
}
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
//extension Double {
//    var clean: String {
//        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
//    }
//    
//   
//}
