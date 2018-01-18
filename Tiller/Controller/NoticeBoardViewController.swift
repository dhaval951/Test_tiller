//
//  NoticeBoardViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class NoticeBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCreatNew: UIButton!
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    
    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var NotificationArray =  [[String : Any]]()
    var DetailDict =  [String : Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
        NotificationArray.removeAll()
//        tableView.reloadData()
        self.callServiceAPI()
    }
    override func viewWillLayoutSubviews() {
        pageNo = 1
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func callServiceAPI()  {
        let param: [String: Any] = [
            "user_id": self.userId ,
            "page" : pageNo
        ]
        print(param)
        self.callServiceAll(Path.notificationList, param: param,methods : .get, completionHandler: { (result) in
            var strmsg : String = ""
            
            if result["status"] as! Bool
            {
                // self.showMessage(message: result["message"] as! String)
                self.NotificationArray.append(contentsOf: result.getArrayofDictionary(key: "notificationList"))
                print(self.NotificationArray)
                self.tableView.reloadData()
                self.pageNo += 1
                self.nextPage = result["has_next"] as! Bool
            }
            else
            {
                if(result.getBool(key: "has_next"))
                {
                    self.showMessage(message: result["message"] as! String)
                }
                strmsg = result["message"] as! String
            }
            if self.NotificationArray.count == 0 {
                self.tableView.setTextForBlankTableview(msg: strmsg)
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeBoardCell", for: indexPath) as! NoticeBoardCell
        let currentRec = NotificationArray[indexPath.row]

        cell.lblUserName.text = currentRec["notifiMessage"] as? String//celebTitle
        if currentRec["notifiType"] as? String == "comment" {
            cell.lblTitle.text = "S"
        }
        else  if currentRec["notifiType"] as? String == "help_request" {
            cell.lblTitle.text = "H"
        }
        else  if currentRec["notifiType"] as? String == "celebrate" {
            cell.lblTitle.text = "C"
        }
        else  if currentRec["notifiType"] as? String == "remove" {
            cell.lblTitle.text = "R"
        }
        else  if currentRec["notifiType"] as? String == "add" {
            cell.lblTitle.text = "A"
        }
        
        let a = currentRec["notifiDate"] as! String
        let b = currentRec["notifiTime"] as! String //"\(String(describing: currentRec["helpTime"] as? String))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: a)
        let day = (date?.getDateFormate())!.capitalized
        let last  = day + " " + b.lowercased()
        cell.lblDate.text = last

        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRec = NotificationArray[indexPath.row]
        
        self.DetailDict = currentRec//data["data"] as! [[String: Any]]
        
        if currentRec["notifiType"] as? String == "comment" {
            Index = indexPath
            self.performSegue(withIdentifier: "HelpRequestDetailsVC", sender: self)
        }
        else  if currentRec["notifiType"] as? String == "help_request" {
            Index = indexPath

            self.performSegue(withIdentifier: "HelpRequestDetailsVC", sender: self)
        }
            
        else  if currentRec["notifiType"] as? String == "celebrate" {
            Index = indexPath

            self.performSegue(withIdentifier: "CelebrateDetailsVC", sender: self)

        }
        else  if currentRec["notifiType"] as? String == "remove" {
            Index = indexPath

            if self.UserType == 2  { //parent
                self.performSegue(withIdentifier: "ChildTribeVC", sender: self)
            }
            else if self.UserType == 1
            {
                self.performSegue(withIdentifier: "MyTribeViewController", sender: self)
            }


        }
        else  if currentRec["notifiType"] as? String == "add" {
            Index = indexPath

            if self.UserType == 2  { //parent
                self.performSegue(withIdentifier: "ChildTribeVC", sender: self)
            }
            else if self.UserType == 1
            {
                self.performSegue(withIdentifier: "MyTribeViewController", sender: self)
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "HelpRequestDetailsVC"
        {
            let destination = segue.destination as! HelpRequestDetailsVC
            let currentRec = NotificationArray[Index.row]
            destination.StrID = String(currentRec["notificationId"] as! Int64)
        }
        else  if segue.identifier == "MyTribeViewController"
        {
            _ = segue.destination as! MyTribeViewController
            if self.UserType == 2 {
                self.appDelegate.selectedMenuIndex = 1
            }
            else if self.UserType == 1{
                self.appDelegate.selectedMenuIndex = 2
            }
            
        }
        else  if segue.identifier == "ChildTribeVC"
        {
            _ = segue.destination as! ChildTribeVC
            if self.UserType == 2 {
                self.appDelegate.selectedMenuIndex = 1
            }
            else if self.UserType == 1{
                self.appDelegate.selectedMenuIndex = 2
            }
            
        }
        else  if segue.identifier == "CelebrateDetailsVC"
        {
            let destination = segue.destination as! CelebrateDetailsVC
            let currentRec = NotificationArray[Index.row]
            destination.StrID = String(currentRec["notificationId"] as! Int64)
            
        }
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
class NoticeBoardCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgClock: UIImageView!
    @IBOutlet weak var btn: UIButton!

}
