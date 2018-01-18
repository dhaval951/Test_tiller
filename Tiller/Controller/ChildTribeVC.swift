//
//  ChildTribeVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 09/03/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class ChildTribeVC: UIViewController,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var userDefault = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var Pop_view: UIView!
    @IBOutlet var Pop_titleName: UILabel!
    @IBOutlet var Pop_Address: UILabel!
    @IBOutlet var Pop_Emaillbl: UILabel!
    @IBOutlet var Pop_Phonelbl: UILabel!
    @IBOutlet var Pop_Chatbtn: UIButton!
    @IBOutlet var Pop_Removebtn: UIButton!
    
    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var MytribeArray =  [[String : Any]]()
    // var MytribeArray = ["Dhaval Bhadania","Sanjay Shah","Tarun Alkayda", "Jasmit Patel", "Chinkal Shah", "Ketul Patel", "Ritesh Patel", "Kuldip Patel", "Jigar Jigo", "Roshan Jha","Amit Trivedi","Dhruv Shah","Hardik Kanasara"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        
        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        tap.delegate = self
        Pop_view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pageNo = 1
        MytribeArray.removeAll()
        tableView.reloadData()
        self.callServiceAPI()
        
    }
    override func viewWillLayoutSubviews() {
        
        pageNo = 1
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
                  //  self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
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
                if self.MytribeArray.count == 0 {
                    self.tableView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.tableView.backgroundView = nil
                }
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
                
                if(result.getBool(key: "status"))
                {
                   // self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
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
                if self.MytribeArray.count == 0 {
                    self.tableView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.tableView.backgroundView = nil
                }
            })
        }
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        Pop_view.isHidden = true
        
    }
    
    @IBAction func btnChatPopOverAction(_ sender: UIButton) {
        //   self.performSegue(withIdentifier: "Mytribe", sender: self)
        print("Chat PopOver Calling here!!!")
        Pop_view.isHidden = true

        performSegue(withIdentifier: "segueChat", sender: self)

    }
    
    @IBAction func btnRemovePopOverAction(_ sender: UIButton) {
        //   self.performSegue(withIdentifier: "Mytribe", sender: self)
        print("Remove  PopOver Calling here!!!")
        let alertController = UIAlertController(title: "Are you sure you want to remove this member?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("no")
            self.tableView.beginUpdates()
            self.Pop_view.isHidden = true
            self.tableView.endUpdates()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "member_id": self.MytribeArray[self.Index.row]["userid"]! ,
                ]
            
            self.callServiceAll(Path.removeTribeMember, param: param,methods : .post, completionHandler: { (result) in
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    self.tableView.beginUpdates()
                    self.Pop_view.isHidden = true
                    self.MytribeArray.remove(at: self.Index.row)
                    self.tableView.deleteRows(at: [self.Index], with: .fade)
                    self.tableView.endUpdates()
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })
        }
        alertController.addAction(NoAction)
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MytribeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MytribeCell", for: indexPath) as! MytribeCell
        
        let currentRec = MytribeArray[indexPath.row]
        
        cell.lblUserName.text = currentRec["fullname"] as? String
        let contactno = "\(currentRec.getInt(key: "contactno"))"
        cell.lblNumber.text  = contactno
        cell.imgUser.setImage(url:currentRec["profile_image"] as! String, placeHolderImage: "child_photo")
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        if indexPath.row == MytribeArray.count - 1 && nextPage
        {
            self.callServiceAPI()
        }
        cell.updateConstraintsIfNeeded()
        cell.selectionStyle = .none
        return cell
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSFontAttributeName: font]
        while mutable.size(attributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let whitespace = whitespaceString(width: 100)
        let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) { (action, indexPath) in
            // do whatever you want
            
            let alertController = UIAlertController(title: "Are you sure you want to remove this member?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("no")
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                self.tableView.reloadData()
            }
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                let param: [String: Any] = [
                    "user_id": self.userId ,
                    "member_id": self.MytribeArray[indexPath.row]["userid"]! ,
                    ]
                
                self.callServiceAll(Path.removeTribeMember, param: param,methods : .post, completionHandler: { (result) in
                    if result["status"] as! Bool
                    {
                        self.showMessage(message: result["message"] as! String)
                        self.tableView.beginUpdates()
                        self.MytribeArray.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }
                    else
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                })
                
            }
            
            alertController.addAction(NoAction)
            alertController.addAction(YesAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        // create a color from patter image and set the color as a background color of action
        let kActionImageSize: CGFloat = 18
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 145))
        view.backgroundColor = UIColor.red
        let imageView = UIImageView(frame: CGRect(x: (100 - kActionImageSize) / 2,
                                                  y: (145 - kActionImageSize) / 2,
                                                  width: 18,
                                                  height: 18))
        imageView.image = UIImage(named: "icon_close")
        view.addSubview(imageView)
        let image = view.image()
        
        deleteAction.backgroundColor = UIColor.init(patternImage: image)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alertController = UIAlertController(title: "Are you sure you want to remove this member?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("no")
                self.tableView.beginUpdates()
                //                self.tableView.reloadData()
                self.tableView.endUpdates()
            }
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                
                let param: [String: Any] = [
                    "user_id": self.userId ,
                    "member_id": self.MytribeArray[indexPath.row]["userid"]! ,
                    ]
                print(param)
                
                self.callServiceAll(Path.removeTribeMember, param: param,methods : .post, completionHandler: { (result) in

                    if result["status"] as! Bool
                    {
                        self.showMessage(message: result["message"] as! String)
                        
                        self.tableView.beginUpdates()
                        self.MytribeArray.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }
                    else
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                })
            }

            alertController.addAction(NoAction)
            alertController.addAction(YesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        Index = indexPath;
//        self.IsVisiblePop_over()
        
    }
    func IsVisiblePop_over() {
        self.view.bringSubview(toFront: self.Pop_view)

        Pop_view.isHidden = false
        let currentRec = MytribeArray[Index.row]
        self.Pop_titleName.text = currentRec["fullname"] as? String
        self.Pop_Address.text  = currentRec["address"] as? String//"A-805,Zealous System PVT. LTD. , Safal Profitaire, Corporate Rd, Prahlad Nagar, Ahmedabad, Gujarat 380015"
        
        self.Pop_Emaillbl.text = currentRec["email"] as? String
        let contactno = "\(currentRec.getInt(key: "contactno"))"
        self.Pop_Phonelbl.text  = contactno
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueChat"
        {
            let destination = segue.destination as! ChatViewController
            var chatDetail = [String: Any]()
            
            chatDetail["receivername"] = "\((MytribeArray[Index.row])["fullname"]!)"
            chatDetail["receiverId"] = "\((MytribeArray[Index.row])["userid"]!)"
            chatDetail["receiverimg"] = "\((MytribeArray[Index.row])["profile_image"]!)"
            destination.ChatDetail = chatDetail
            
        }
    }
    
}
    




