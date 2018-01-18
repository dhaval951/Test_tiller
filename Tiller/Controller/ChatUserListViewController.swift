//
//  ChatUserListViewController.swift
//
//  Created by Dhaval Bhadania on 06/10/16.
//  Copyright © 2016 Dhaval Bhadania. All rights reserved.
//

import UIKit

class ChatUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, OnlineStatusDelegate, ChatUserDelegate
{
    // MARK: - Chat delegate
    func reloadtable() {
    
        getMessages()
        tableView.reloadData()
      
    }
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!

    //MARK: - Declaration
    var arrChatuser = [[String : Any]]()
    var arrCurrentArray = [[String : Any]]()
    var arrNames = [String]()
    var CurrentsenderId: String!
    var searchActive : Bool = false
    var selectedIndex = -1
    var arrOnlineUsers: [String]!
    
    //MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        // Do any additional setup after loading the view.
        
        appDelegate.chatUserDelegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
       
        appDelegate.onlineUsersDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
      //  setMessageCount()
    }
    override func viewDidAppear(_ animated: Bool) {
        getMessages()

    }

    func getMessages()
    {
        arrNames.removeAll()
       // if isLogedin
        //{
            self.arrChatuser.removeAll()
            
            let cd = CoreDataStack()
            CurrentsenderId = String(format: "tiller_%@","\(userId)")

            let chatmsg = cd.getChatUserlist(senderId: String(CurrentsenderId))
            print ("chatmsg is :%@",chatmsg)

            var  tempmsg = [String] ()
            
            for msg in chatmsg
            {
                if (msg["senderId"] as! String) == UserDefaults.standard.string(forKey: "chatusername")
                {
                    if tempmsg.contains(msg["receiverId"] as! String)
                    {
                        continue
                    }
                    tempmsg.append(msg["receiverId"] as! String)
                    arrChatuser.append(msg)
                }
                else
                {
                    if tempmsg.contains(msg["senderId"] as! String)
                    {
                        continue
                    }
                    tempmsg.append(msg["senderId"] as! String)
                    arrChatuser.append(msg)
                }
            }
            if self.arrChatuser.count == 0 {
                self.tableView.setTextForBlankTableview(msg: "No chat(s) found!")
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
            
            setMessageCount()
            
            print ("arrChatuser is :%@",arrChatuser)
            
            for user in arrChatuser
            {
                if "\(user["type"]!)" == "outgoing"
                {
                    arrNames.append(user["receivername"] as! String)
                }
                else
                {
                    arrNames.append(user["sendername"] as! String)
                }
            }
            
            self.tableView.reloadData()
       // }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       
            return arrChatuser.count
      
//        return arrChatuser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatUserListCell
        
        var Currentrec: [String: Any]
        Currentrec = arrChatuser[indexPath.row]
        
        cell.lblMessage.text = Currentrec["message"] as? String
        cell.lblTime.text =   Date(timeIntervalSince1970: Double(Currentrec["timeStemp"] as! String)!).wholedate()

        if "\(Currentrec["type"]!)" == "outgoing"
        {
            cell.lblUserName.text = Currentrec["receivername"] as? String
            cell.imgUser.setImage(url: Currentrec["receiverimg"] as! String, placeHolderImage: "profile_default_img")
        }
        else
        {
            cell.lblUserName.text = Currentrec["sendername"] as? String
            cell.imgUser.setImage(url: Currentrec["senderimg"] as! String, placeHolderImage: "profile_default_img")
        }
        if Currentrec["isRead"] as! String == "NO"
        {
            cell.imgBackground.backgroundColor = #colorLiteral(red: 0.9498776793, green: 0.9532684684, blue: 0.9594311118, alpha: 1)
        }
        else
        {
            cell.imgBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        
        cell.updateConstraintsIfNeeded()
        cell.selectionStyle = .none
        return cell
    }
    func BtnTap(_ sender: UIButton) {
        let value = sender.tag;
        
        let button = sender
        let indexPath = self.tableView.indexPathForView(view: button)!
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segueChat", sender: self)
        print(value)
        //        NSLog(@"the butto, on cell number... %d", theCellClicked.tag);
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segueChat", sender: self)
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
            
            let alertController = UIAlertController(title: "Are you sure you want to delete Chat?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
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
                self.showProgressHud(msg: "")
                
                self.tableView.beginUpdates()
                let  Currentrec = self.arrChatuser[indexPath.row]
                let senderID = "\(Currentrec["senderId"]!)"
                let receiverId = "\(Currentrec["receiverId"]!)"
                self.appDelegate.coreDataStack.delete(senderId: senderID, receiverId: receiverId);
                self.tableView.endUpdates()
                //fetch again whole DB data here and display
                self.getMessages()
                self.hideProgressHud()
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            let alertController = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
//            
//            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
//                (result : UIAlertAction) -> Void in
//                print("no")
//                self.tableView.beginUpdates()
//                //                self.tableView.reloadData()
//                self.tableView.endUpdates()
//            }
//            
//            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
//                (result : UIAlertAction) -> Void in
//                self.showProgressHud(msg: "")
//                self.tableView.beginUpdates()
//                let  Currentrec = self.arrChatuser[indexPath.row]
//                let senderID = "\(Currentrec["senderId"]!)"
//                let receiverId = "\(Currentrec["receiverId"]!)"
//                self.appDelegate.coreDataStack.delete(senderId: senderID, receiverId: receiverId);
//                self.tableView.endUpdates()
//                //fetch again whole DB data here and display
//                self.getMessages()
//                self.hideProgressHud()
//
//
//            }
//            
//            alertController.addAction(NoAction)
//            alertController.addAction(YesAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueChat"
        {
            let destination = segue.destination as! ChatViewController
            var chatDetail = [String: Any]()
            if "\((arrChatuser[selectedIndex])["type"]!)" == "outgoing"
            {
                chatDetail["receivername"] = "\((arrChatuser[selectedIndex])["receivername"]!)"
                chatDetail["receiverId"] = "\((arrChatuser[selectedIndex])["receiverId"]!)"
                chatDetail["receiverimg"] = "\((arrChatuser[selectedIndex])["receiverimg"]!)"

                let CurrentsenderId = String(format: "tiller_%@","\(userId)")
                let receiveridis = "\((arrChatuser[selectedIndex])["receiverId"]!)"
                if (receiveridis == CurrentsenderId) {
                    chatDetail["receivername"] = "\((arrChatuser[selectedIndex])["sendername"]!)"
                    chatDetail["receiverId"] = "\((arrChatuser[selectedIndex])["senderId"]!)"
                    chatDetail["receiverimg"] = "\((arrChatuser[selectedIndex])["senderimg"]!)"
                }
                destination.ChatDetail = chatDetail
            }
            else
            {
                chatDetail["receivername"] = "\((arrChatuser[selectedIndex])["sendername"]!)"
                chatDetail["receiverId"] = "\((arrChatuser[selectedIndex])["senderId"]!)"
                chatDetail["receiverimg"] = "\((arrChatuser[selectedIndex])["senderimg"]!)"
                destination.ChatDetail = chatDetail
            }
        }

    }

    func onlineUsersList(users: [String]) {
        
        arrOnlineUsers = users
        getMessages()
//        tableView.reloadData()
    }
    
    @IBAction func btnSignupAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "segueSignup", sender: self)
    }
    //Menu helper method
    override func setNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    override func removeNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }

}
var isLogedin: Bool
{
    return UserDefaults.standard.value(forKey: "user_id") != nil
}
func setMessageCount()
{
//    if isLogedin
//    {
//        let cd = CoreDataStack()
//        let messageCount = cd.getMessageCount()
//        if messageCount != 0
//        {
//            self.tabBarController?.tabBar.items![1].badgeValue = "\(messageCount)"
//        }
//        else
//        {
//            self.tabBarController?.tabBar.items![1].badgeValue = nil
//        }
//    }
}
