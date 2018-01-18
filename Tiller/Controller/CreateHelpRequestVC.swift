//
//  CreateHelpRequestVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 14/03/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class CreateHelpRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!

    @IBOutlet var btnradio: [UIButton]!
    
    @IBOutlet weak var btnCustom1: UIButton!
    @IBOutlet weak var btnCustom2: UIButton!
    @IBOutlet weak var btnCustom3: UIButton!
    var selectedItems = NSMutableArray()

    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var MytribeArray =  [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

         btnradio[0].isSelected = true
        txtview.delegate = self
            //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedItems.removeAllObjects()
        pageNo = 1
        MytribeArray.removeAll()
        tableView.reloadData()
        self.callServiceAPI()
        
    }
    func callServiceAPI()  {
        
        
        if self.UserType == 2
        {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "page" : pageNo
            ]
            print(param)
            self.callServiceAll(Path.childTribeList, param: param,methods : .get, completionHandler: { (result) in
                var strmsg : String = ""
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
                    self.tableView.reloadData()
                    self.pageNo += 1
                    self.nextPage = result["has_next"] as! Bool
                }
                else
                {
                    
                    if (result["has_next"] as! Bool)
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                    strmsg = result["message"] as! String
                }
                if self.MytribeArray.count == 0 {
                    self.tableView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            })
        }
        else if self.UserType == 1
        {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "page" : pageNo
            ]
            print(param)
            self.callServiceAll(Path.parentTribeList, param: param,methods : .get, completionHandler: { (result) in
                var strmsg : String = ""
                
                if result["status"] as! Bool
                {
                    // self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
                    self.tableView.reloadData()
                    self.pageNo += 1
                    self.nextPage = result["has_next"] as! Bool
                }
                else if result["status"] as! Bool == false
                {
                    if (result["has_next"] as! Bool)
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                    strmsg = result["message"] as! String
                }
                if self.MytribeArray.count == 0 {
                    self.tableView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.tableView.backgroundView = nil
                }
            })
            
        }
        
        
        
    }

    override func viewWillLayoutSubviews() {
        
        pageNo = 1
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MytribeArray.count

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 55, y: 0,width: tableView.frame.size.width - 150, height: 30))
        headerLabel.text = "My Tribe"
        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        headerView.addSubview(headerLabel)

        let AddLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 100, y: 0,width: 100, height: 30))
        AddLabel.text = "Add"
        AddLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        AddLabel.numberOfLines = 0
        AddLabel.textAlignment = .center
        AddLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        headerView.addSubview(AddLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mytribe_RequestCell", for: indexPath) as! Mytribe_RequestCell
        let currentRec = MytribeArray[indexPath.row]
        
        cell.lblUserName.text = currentRec["fullname"] as? String
        cell.imgUser.setImage(url:currentRec["profile_image"] as! String, placeHolderImage: "profile_default_img")
        cell.Btncheckmark.tag = indexPath.row
        cell.Btncheckmark.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        if (self.selectedItems.contains(self.MytribeArray[indexPath.row]["userid"] as! Int ))
        {
            cell.Btncheckmark.isSelected = true
        }else{
            cell.Btncheckmark.isSelected = false
        }
        cell.Btncheckmark.isHidden = false
        cell.selectionStyle = .none
        return cell
        
    }
    func BtnTap(_ sender: UIButton) {
        let value = sender.tag;
        
        let button = sender
        let indexPath = self.tableView.indexPathForView(view: button)!
        Index = indexPath as IndexPath!
       // self.IsVisiblePop_over()
        print(value)
        if self.selectedItems.contains(self.MytribeArray[Index.row]["userid"] as! Int ) {
            self.selectedItems.remove(self.MytribeArray[Index.row]["userid"] as! Int )
        }
        else{
            self.selectedItems.add(self.MytribeArray[Index.row]["userid"] as! Int )
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedItems.contains(self.MytribeArray[indexPath.row]["userid"] as! Int ) {
            self.selectedItems.remove(self.MytribeArray[indexPath.row]["userid"] as! Int )
        }
        else{
            self.selectedItems.add(self.MytribeArray[indexPath.row]["userid"] as! Int )
        }
        self.tableView.reloadData()

    }

    @IBAction func btnCustom1Action(_ sender: UIButton) {
        btnradio[0].isSelected = true
        btnradio[1].isSelected = false
        btnradio[2].isSelected = false
        
    }
    @IBAction func btnCustom2Action(_ sender: UIButton) {

        btnradio[1].isSelected = true
        btnradio[2].isSelected = false
        btnradio[0].isSelected = false
    }
    @IBAction func btnCustom3Action(_ sender: UIButton) {
   
        btnradio[2].isSelected = true
        btnradio[1].isSelected = false
        btnradio[0].isSelected = false
    }
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if self.MytribeArray.count == 0 {
            self.showMessage(message: "Please add tribe memeber first")
            return;
        }
        if self.selectedItems.count == 0 {
            self.showMessage(message: "Please select tribe.")
            return;
        }
        
        let strtxt1 = txtview.text
        var strtxt : String =  (strtxt1?.trimmingCharacters(in: .whitespacesAndNewlines))!

        if ( strtxt.contains("Any more")) {
            strtxt = ""
        }
        if strtxt.characters.count == 0{
            self.showMessage(message: "Please write something in description")
            return;
        }
        var stringmember_ids = ""
        if self.selectedItems.count > 0 {
            stringmember_ids = self.selectedItems.componentsJoined(by: ",")
            print(stringmember_ids)
        }
        
        
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "dd/MM/yyyy"
        let Strdate = dateFormattor.string(from: Date())
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "hh:mm a"
        let strtime = dateFormatterTime.string(from: Date())
        
        var strTitle : String = ""
        if btnradio[0].isSelected == true {
            strTitle = "Need you now!"
        }
        else if btnradio[1].isSelected == true {
            strTitle = "When you've got a minute."
        }
        else if btnradio[2].isSelected == true {
            strTitle = "Want to let you know."
        }
        
        let param: [String: Any] = [
            "user_id": self.userId ,
            "helprequest_title":strTitle ,
            "helprequest_desc":strtxt ,
            "helprequest_time":strtime ,
            "helprequest_date":Strdate ,
            "helprequest_timezone":self.localTimeZoneIdentifier ,
            "member_ids":stringmember_ids ,
            ]
        
        self.callServiceAll(Path.addHelpRequest, param: param,methods : .post, completionHandler: { (result) in
            
            if result["status"] as! Bool
            {
                self.showMessage(message: result["message"] as! String)
//                if self.UserType == 2 {
//                    self.appDelegate.selectedMenuIndex = 1
//                }
//                else if self.UserType == 1{
//                    self.appDelegate.selectedMenuIndex = 2
//                }
//               // self.performSegue(withIdentifier: "MyTribeViewController", sender: self)
                _ = self.navigationController?.popViewController(animated: true)

            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })
        
        
    }
    // MARK: - UITextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Any more information?"
        {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
//        if updatedString?.characters.count == 0 {
//            textView.text = "Any more information?"
//            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        }
        if (updatedString?.contains("Any more"))! {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = "Any more information?"
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
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
//MARK: - ChatUserList cell
class Mytribe_RequestCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var Btncheckmark: UIButton!
    
}
