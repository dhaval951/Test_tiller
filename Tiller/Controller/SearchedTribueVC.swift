//
//  SearchedTribueVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 03/03/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class SearchedTribueVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var SearchtribeArray = [[String: Any]]()
    var arrTribe = [[String: Any]]()
    var selectedItems = NSMutableArray()

    @IBOutlet weak var btnAddInTribue: UIButton!
    var Index: IndexPath!

    //Popover
    @IBOutlet var Pop_view: UIView!
    @IBOutlet var Pop_titleName: UILabel!
    @IBOutlet var Pop_Address: UILabel!
    @IBOutlet var Pop_Emaillbl: UILabel!
    @IBOutlet var Pop_Phonelbl: UILabel!
    @IBOutlet var Pop_Chatbtn: UIButton!
    @IBOutlet var Pop_Removebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        tap.delegate = self
        Pop_view.addGestureRecognizer(tap)

    }
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        Pop_view.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedItems.removeAllObjects()
        self.SearchtribeArray.removeAll()
        
        if arrTribe.count > 0 {
            SearchtribeArray = arrTribe
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchtribeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchtribeCell", for: indexPath) as! SearchtribeCell
        let currentRec = SearchtribeArray[indexPath.row]
        cell.lblUserName.text =  currentRec["fullname"] as? String
        let contactno = "\(currentRec.getInt(key: "contactno"))"
        cell.lblNumber.text  = contactno
        cell.imgUser.setImage(url:currentRec["profile_image"] as! String, placeHolderImage: "profile_default_img")
        
        if (self.selectedItems.contains(self.SearchtribeArray[indexPath.row]["userid"] as! Int ))
        {
            cell.imgCheckMark.image = UIImage(named:"check_mark")
        }else{
            cell.imgCheckMark.image = UIImage(named:"check_mark_without")
        }
        cell.btnContact.tag = indexPath.row
        cell.btnContact.addTarget(self, action:#selector(self.BtnDialer(_:)), for: .touchUpInside)
        
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        cell.updateConstraintsIfNeeded()
        cell.selectionStyle = .none
        return cell
        
    }
    func BtnDialer(_ sender: UIButton) {
        let button = sender
        let indexPath = self.tableView.indexPathForView(view: button)!
        Index = indexPath as IndexPath!
        let currentRec = SearchtribeArray[Index.row]
        let contactno = "\(currentRec.getInt(key: "contactno"))"
        self.callNumber(phoneNumber: contactno)
    }
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://"+"\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL as URL)
                } else {
                    application.openURL(phoneCallURL as URL)
                };
            }
        }
        
        //        var info = CTTelephonyNetworkInfo()
        //        var carrier = info.subscriberCellularProvider
        //        if carrier != nil && carrier.mobileNetworkCode == nil || carrier.mobileNetworkCode.isEqual("") {
        //            //SIM is not there in the phone
        //        }
        //        else if UIApplication.sharedApplication().canopenURL(NSURL(string: "tel://9809088798")!)
        //        {
        //            UIApplication.sharedApplication().openURL(NSURL(string: "tel://9809088798")!)
        //        }
        //        else
        //        {
        //            //Device does not have call making capability
        //        }
    }
    func BtnTap(_ sender: UIButton) {
        let value = sender.tag;
        
        let button = sender
        let indexPath = self.tableView.indexPathForView(view: button)!
        Index = indexPath as IndexPath!
        self.IsVisiblePop_over()
        print(value)
        //        NSLog(@"the butto, on cell number... %d", theCellClicked.tag); 9993548348
        
    }
    func IsVisiblePop_over() {
        self.view.bringSubview(toFront: self.Pop_view)
        Pop_view.isHidden = false
        let currentRec = SearchtribeArray[Index.row]
        self.Pop_titleName.text = currentRec["fullname"] as? String
        self.Pop_Address.text  = currentRec["address"] as? String//"A-805,Zealous System PVT. LTD. , Safal Profitaire, Corporate Rd, Prahlad Nagar, Ahmedabad, Gujarat 380015"
        
        self.Pop_Emaillbl.text = currentRec["email"] as? String
        let contactno = "\(currentRec.getInt(key: "contactno"))"
        self.Pop_Phonelbl.text  = contactno
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.selectedItems.contains(self.SearchtribeArray[indexPath.row]["userid"] as! Int ) {
            self.selectedItems.remove(self.SearchtribeArray[indexPath.row]["userid"] as! Int )
        }
        else{
            self.selectedItems.add(self.SearchtribeArray[indexPath.row]["userid"] as! Int )
        }
        
        
        self.tableView.reloadData()

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - Button action
    @IBAction func btnAddinTribueAction(_ sender: UIButton) {
        if self.selectedItems.count == 0 {
            self.showMessage(message: "Please select tribe.")
            return;
        }
        var stringRepresentation = ""
        if self.selectedItems.count > 0 {
             stringRepresentation = self.selectedItems.componentsJoined(by: ",")
            print(stringRepresentation)
        }

        let param: [String: Any] = [
            "user_id": self.userId ,
            "member_id":stringRepresentation ,
        ]

        self.callServiceAll(Path.addTribeMember, param: param,methods : .post, completionHandler: { (result) in

            if result["status"] as! Bool
            {
                self.showMessage(message: result["message"] as! String)
                if self.UserType == 2 {
                    self.appDelegate.selectedMenuIndex = 1
                }
                else if self.UserType == 1{
                    self.appDelegate.selectedMenuIndex = 2
                }
                self.performSegue(withIdentifier: "MyTribeViewController", sender: self)                
            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })


    }
}
//MARK: - ChatUserList cell
class SearchtribeCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCheckMark: UIImageView!

    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnContact: UIButton!

}
