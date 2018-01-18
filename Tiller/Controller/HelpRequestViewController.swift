//
//  HelpRequestViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class HelpRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    //var RequestArray = ["Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer","Ben Summer"]
    @IBOutlet weak var btnCreatNew: UIButton!
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    
    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var RequestArray =  [[String : Any]]()
    var DetailDict =  [String : Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()

//      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        if self.UserType == 2 {
            constBottom.constant =  0
        }
        else if self.UserType == 1{
            constBottom.constant =  45
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
        RequestArray.removeAll()
        tableView.reloadData()
        self.callServiceAPI()
    }
    
    func callServiceAPI()  {
        let param: [String: Any] = [
            "user_id": self.userId ,
            "page" : pageNo
        ]
            print(param)
            self.callServiceAll(Path.helpRequestList, param: param,methods : .get, completionHandler: { (result) in
                var strmsg : String = ""
                
                if result["status"] as! Bool
                {
                   // self.showMessage(message: result["message"] as! String) sbin0060089
                    self.RequestArray.append(contentsOf: result.getArrayofDictionary(key: "helpRequestList"))
                    
                    self.tableView.reloadData()
                    self.pageNo += 1
                    self.nextPage = result["has_next"] as! Bool
                }
                else
                {
                    
                    if (result.getBool(key: "has_next"))
                    {
                        self.showMessage(message: result["message"] as! String)
                        
                    }
                    strmsg = result["message"] as! String
                }
                if self.RequestArray.count == 0 {
                    self.tableView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            })
   
    }
    override func viewWillLayoutSubviews() {
        
        pageNo = 1
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpRequestCell", for: indexPath) as! HelpRequestCell
        let currentRec = RequestArray[indexPath.row]

        cell.lblUserName.text = currentRec["helpCreatedby"] as? String
        cell.lblDetails.text = currentRec["helpDesc"] as? String
        cell.imgUser.setImage(url:currentRec["helpCreatedbyImg"] as! String, placeHolderImage: "profile_default_img")

        let a = currentRec["helpDate"] as! String
        let b = currentRec["helpTime"] as! String //"\(String(describing: currentRec["helpTime"] as? String))"
        
//        let last  = a + " " + b
        
        
//        let a = currentRec["commentDate"] as! String
//        let b = currentRec["commentTime"] as! String
        //  let last  = a + " " + b
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: a)
        let day = (date?.getDateFormate())!.capitalized
        let last  = day + " " + b.lowercased()
        cell.lblDate.text = last

        let AryComent : NSArray = (currentRec["commentList"] as? NSArray)!

        if (AryComent.count > 0)
        {
            cell.imgonline.image = UIImage(named: "dot_green")

        }else{
            cell.imgonline.image = UIImage(named: "dot_red")
        }
        if indexPath.row == RequestArray.count - 1 && nextPage
        {
            self.callServiceAPI()
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRec = RequestArray[indexPath.row]
        
        self.DetailDict = currentRec//data["data"] as! [[String: Any]]

        self.performSegue(withIdentifier: "HomeDetails", sender: self)
//        self.performSegue(withIdentifier: "HelpRequestDetailsVC", sender: self)

    }




    // MARK: - Button action
    @IBAction func btnCreateNewAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateHelpRequestVC", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateHelpRequestVC"
        {
            let destination = segue.destination as! CreateHelpRequestVC
//            destination.IsEdit = IsEdit
//            destination.StrDate = StrSelectDate
//            destination.SelctedDate = SelectedDate
//            
//            if (tempDict.count > 0)
//            {
//                destination.tempDict = tempDict
//            }
            
        }
        if segue.identifier == "HelpRequestDetailsVC"
        {
            let destination = segue.destination as! HelpRequestDetailsVC

            destination.DetailDict = self.DetailDict
            
            //            destination.StrDate = StrSelectDate
            //            destination.SelctedDate = SelectedDate
            //
            //            if (tempDict.count > 0)
            //            {
            //                destination.tempDict = tempDict
            //            }
            
        }
        if segue.identifier == "HomeDetails"
        {
            let destination = segue.destination as! HomeVC
            destination.DetailDict = self.DetailDict

            //            destination.IsEdit = IsEdit
            //            destination.StrDate = StrSelectDate
            //            destination.SelctedDate = SelectedDate
            //
            //            if (tempDict.count > 0)
            //            {
            //                destination.tempDict = tempDict
            //            }
            
        }
    }


}
//MARK: - ChatUserList cell
class HelpRequestCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgClock: UIImageView!

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgonline: UIImageView!

}
