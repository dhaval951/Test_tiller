//
//  CelebrateWithMeVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 19/04/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class CelebrateWithMeVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCreatNew: UIButton!
    var DetailDict =  [String : Any]()

    @IBOutlet weak var constBottom: NSLayoutConstraint!
    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var RequestArray =  [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        if self.UserType == 2 {
            constBottom.constant =  0
        }
        else if self.UserType == 1{
            constBottom.constant =  42
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
        self.callServiceAll(Path.celebrateList, param: param,methods : .get, completionHandler: { (result) in
            var strmsg : String = ""
            
            if result["status"] as! Bool
            {
                //self.showMessage(message: result["message"] as! String)
                self.RequestArray.append(contentsOf: result.getArrayofDictionary(key: "celebrateList"))
                
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
        self.tableView.estimatedRowHeight = 44
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrateWithMeCell", for: indexPath) as! CelebrateWithMeCell
        let currentRec = RequestArray[indexPath.row]
        
        cell.lblUserName.text = currentRec["celebTitle"] as? String//celebTitle
        
        let a = currentRec["celebDate"] as! String
        let b = currentRec["celebTime"] as! String //"\(String(describing: currentRec["helpTime"] as? String))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: a)
        let day = (date?.getDateFormate())!.capitalized
        let last  = day + " " + b.lowercased()
        cell.lblDate.text = last
        //90600636
        //47840881
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
        
        self.performSegue(withIdentifier: "CelebrateDetailsVC", sender: self)
        
    }
    // MARK: - Button action
    @IBAction func btnCreateNewAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateCelebrateVC", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateCelebrateVC"
        {
            let destination = segue.destination as! CreateCelebrateVC
            //            destination.IsEdit = IsEdit
            //            destination.StrDate = StrSelectDate
            //            destination.SelctedDate = SelectedDate
            //
            //            if (tempDict.count > 0)
            //            {
            //                destination.tempDict = tempDict
            //            }
            
        }
        if segue.identifier == "CelebrateDetailsVC"
        {
            let destination = segue.destination as! CelebrateDetailsVC
            
            destination.DetailDict = self.DetailDict
            
            //            destination.StrDate = StrSelectDate
            //            destination.SelctedDate = SelectedDate
            //
            //            if (tempDict.count > 0)
            //            {
            //                destination.tempDict = tempDict
            //            }
            
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
class CelebrateWithMeCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgClock: UIImageView!

}
