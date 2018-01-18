//
//  ChatViewController.swift
//  tiller_acancy
//
//  Created by Rohit Parsana on 06/10/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import UIKit
import CoreData
import  XMPPFramework
//import XMPPManager
class MailData {
    var from: String!;
    var subject: String!;
    var message: String!;
    var date: String!;
    var read = false;
    var flag = false;
}
var timestamp: String {
    return "\(NSDate().timeIntervalSince1970)"
}


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChatDelegate,MGSwipeTableCellDelegate
{
    @IBOutlet weak var img: UIImageView!

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: NextGrowingTextView!
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    var demoData = [MailData]();

    var userDetail: [String: Any]!
    var ChatDetail: [String: Any]!
    var arrTimeLabels: [String]!
    var arrTimeLabelText: [String]!
    
    var StrlblTitle: String!

    var CurrentuserId: String!
    var CurrentsenderId: String!
    var Index: IndexPath!
    var selectedItems = NSMutableArray()

    var Img_url : String!
    //MARK: - Declaration
    var arrMsg = [[String : Any]]()
    var arrMsgUrl = [[String : Any]]()
//    func didSwipe(recognizer: UIGestureRecognizer) {
//        if recognizer.state == UIGestureRecognizerState.ended {
//            let swipeLocation = recognizer.location(in: self.tableView)
//            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation)
//            {
//                if let swipedCell = self.tableView.cellForRow(at: swipedIndexPath){
//                    
//                    print(swipedCell)
//                }// Swipe happened. Do stuff!
//                
//            }
//        }
//    }
//    func swipeDown() {
//        print("A")
//    }
    //MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.chatDelegate = self
        
//        let recognizer = UISwipeGestureRecognizer(target: self, action:  #selector(self.didSwipe(recognizer:)))
//        self.tableView.addGestureRecognizer(recognizer)
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.hideKeyboard(_:)))
//        tableView.addGestureRecognizer(tapGesture)
//        
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        tableView.addGestureRecognizer(swipeRight)
//        
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.left
//        tableView.addGestureRecognizer(swipeDown)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
           view.layoutIfNeeded()
        
        txtMessage.layer.cornerRadius = 4
        txtMessage.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 4, right: 0)
        txtMessage.placeholderAttributedText =
            NSAttributedString(string: "Type your message here...",
                               attributes: [NSFontAttributeName: self.txtMessage.font!,
                                            NSForegroundColorAttributeName: UIColor.gray
                ]
        )
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loaderMessage : String = ""
        self.showProgressHud(msg: loaderMessage)

        if ChatDetail != nil
        {
            StrlblTitle = ChatDetail["receivername"]! as? String
            CurrentuserId = String(format: "tiller_%@", "\(ChatDetail["receiverId"] as! String)")
            if CurrentuserId.contains("tiller_tiller_") {
                CurrentuserId = String(format: "%@", "\(ChatDetail["receiverId"] as! String)")
            }
            Img_url = UserDefaults.standard.value(forKey: "user_image") as! String!
            
            
            if Img_url == nil {
                Img_url = ChatDetail["receiverimg"]! as? String
            }
            let user = "\(userId)"
            CurrentsenderId = String(format: "tiller_%@", user)
            print("CurrentuserId :%@ and CurrentsenderId :%@ ",CurrentuserId,CurrentsenderId)
 
            appDelegate.chatUserName = CurrentuserId
            appDelegate.isOnChat = true
            
            loadMessage()
            self.appDelegate.coreDataStack.update(senderId: CurrentuserId)
        }
        self.hideProgressHud()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedItems.removeAllObjects()

    }
    
    func loadMessage()  {
        
        let cd = CoreDataStack()
        
        arrMsg = cd.getMessage(senderId: String(CurrentsenderId), receiverId: String(CurrentuserId))
        
        arrMsgUrl = cd.getLastMsgImage(senderId: String(CurrentsenderId), receiverId: String(CurrentuserId))
        
        calculateTimeLabel()
   
        self.tableView.reloadData()
        
        if (self.arrMsg.count > 0)
        {
            let topIndexPath = IndexPath(row: arrMsg.count - 1, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }

    func calculateTimeLabel()
    {
        arrTimeLabels = [String]()
        arrTimeLabelText = [String]()
        for i in 0..<arrMsg.count
        {
            arrTimeLabelText.append("")
            let currentRocd = arrMsg[i]
            let date = Date(timeIntervalSince1970: Double(currentRocd["timeStemp"] as! String)!) .timeAgoSinceDate2()
            
            if !arrTimeLabels.contains(date)
            {
                arrTimeLabels.append(date)
                arrTimeLabelText[i] = date
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
         appDelegate.isOnChat = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                constBottom.constant =  15
                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                constBottom.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    if (self.arrMsg.count > 0)
                    {
                        let topIndexPath = IndexPath(row: self.arrMsg.count - 1, section: 0)
                        self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
                    }
                })
            }
        }
    }
    
    func hideKeyboard(_ sender: UIGestureRecognizer)
    {
        view.endEditing(true)
    }

    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMsg.count
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction ==  UISwipeGestureRecognizerDirection.right{
                
                    if swipeGesture.state == UIGestureRecognizerState.ended
                    {
                        let swipeLocation = swipeGesture.location(in: self.tableView)
                        
                        if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation)
                        {
                            if self.tableView.cellForRow(at: swipedIndexPath) != nil
                            {
                              //  print(swipedCell)
                              //  print("Swiped right")
                                let indexvalue : IndexPath  = tableView.indexPathForRow(at: swipeLocation)! as IndexPath
                         
                                if self.selectedItems.contains(indexvalue.row) {
                                    self.selectedItems.remove(indexvalue.row)
                                }
                                else{
                                    self.selectedItems.add(indexvalue.row)
                                }
                                tableView.reloadRows(at: [indexvalue], with: .none)
                            }
                        }
                    }
            }
            else if swipeGesture.direction ==  UISwipeGestureRecognizerDirection.left{
                
                if swipeGesture.state == UIGestureRecognizerState.ended
                {
                    let swipeLocation = swipeGesture.location(in: self.tableView)
                    
                    if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation)
                    {
                        if self.tableView.cellForRow(at: swipedIndexPath) != nil
                        {
                           // print(swipedCell)
                           // print("Swiped left")
                            let indexvalue : IndexPath  = tableView.indexPathForRow(at: swipeLocation)! as IndexPath
                            if self.selectedItems.contains(indexvalue.row) {
                                self.selectedItems.remove(indexvalue.row)
                            }
                            else{
                                self.selectedItems.add(indexvalue.row)
                            }
                            tableView.reloadRows(at: [indexvalue], with: .none)
                        }
                    }
                }
            }

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentRocd = arrMsg[indexPath.row]
//        arrTimeIndex.append(0)

//        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8
//        {
        if currentRocd["type"] as! String != "outgoing"
        {
        
            let cell : MailTableCell  = tableView.dequeueReusableCell(withIdentifier: "cellReceive", for: indexPath) as! MailTableCell
                        
            cell.lblMessage.text = currentRocd["message"] as? String
            cell.delegate = self;
            
            
            if arrMsgUrl.count > 0 {
                let lastrec = arrMsgUrl.last
                cell.imgUser.setImage(url: lastrec?["senderimg"] as! String, placeHolderImage: "profile_default_img")
            }
            else{
                cell.imgUser.setImage(url: currentRocd["senderimg"] as! String, placeHolderImage: "profile_default_img")
            }
//            let lastrec = arrMsgUrl.last
//            cell.imgUser.setImage(url: lastrec?["senderimg"] as! String, placeHolderImage: "profile_default_img")
            //Last time chat
            img = cell.imgUser
            
            cell.lblStatus.isHidden = true;
            cell.lblTime.isHidden = true;
            cell.imgClock.isHidden = true;

            cell.updateConstraintsIfNeeded()
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSent", for: indexPath) as! MailTableCell
            
            cell.lblMessage.text = currentRocd["message"] as? String
            cell.imgUser.setImage(url: UserDefaults.standard.value(forKey: "user_image") as! String!, placeHolderImage: "profile_default_img")
   
            cell.delegate = self;
            cell.lblStatus.isHidden = true;
            cell.lblTime.isHidden = true;
            cell.imgClock.isHidden = true;

            cell.updateConstraintsIfNeeded()
            cell.selectionStyle = .none
            return cell
        }
    }
 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

//    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat , StrTime: String) -> String {
//        let kPadding: CGFloat = 0
//        let mutable = NSMutableString(string: StrTime)
//        let attribute = [NSFontAttributeName: font]
//        while mutable.size(attributes: attribute).width < width - (2 * kPadding) {
//            mutable.append(" ")
//        }
//        return mutable as String
//    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let currentRocd = arrMsg[indexPath.row]
//        let whitespace = whitespaceString(width: 100, StrTime: Date(timeIntervalSince1970: Double(currentRocd["timeStemp"] as! String)!).wholedate())
//        let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) { (action, indexPath) in
//            // do whatever you want
//            
//        }
//        
//        // create a color from patter image and set the color as a background color of action
//       // let kActionImageSize: CGFloat = 18
////        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 145))
////        view.backgroundColor = UIColor.lightGray
//
//      //  view.addSubview(imageView)
//     // let image = view.image()
//        
//        deleteAction.backgroundColor = UIColor.gray
//        return [deleteAction]
//    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    
    @IBAction  func btnSendAction(sender: UIButton) {
        
        if !isReachabel
        {
            showMessage(message: ToastMsg.Rechability)
            return;
        }
        //NOW send message
        if txtMessage.text.Trimming() == "" || txtMessage.text == "Type your message here..." || txtMessage.text.characters.count == 0
        {
            return;
        }
        //NOW send message
        if txtMessage.text != "" && txtMessage.text != "Type your message here..."
        {
             txtMessage.text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let messageStr: String = txtMessage.text!
            let body = DDXMLElement.element(withName: "body", stringValue: messageStr) as! DDXMLElement
  
          //  let CurrentUSerNAme = UserDefaults.standard.value(forKey: "chatusername")
         //   _ = String(format: "%@", CurrentUSerNAme as! CVarArg)
            
            let message = DDXMLElement.element(withName: "message") as! DDXMLElement
            message.addAttribute(withName: "type", stringValue: "chat")
            message.addAttribute(withName: "to", stringValue: String(format: "%@@%@", CurrentuserId ,BasePath.hostName))
            message.addAttribute(withName: "Username", stringValue:UserDefaults.standard.value(forKey: "user_name") as! String)
            
            message.addChild(body)
            
            // Subject must be : Username,type,url,timestamp where usesrname is name of user , type is one2one for 1 or group 0
            let sub = "\(UserDefaults.standard.value(forKey: "user_name")!),1,\(Img_url!),\(timestamp)"
            let subject = DDXMLElement.element(withName: "subject", stringValue: sub) as! DDXMLElement
            message.addChild(subject)

            let senderid = DDXMLElement.element(withName: "senderid", stringValue: CurrentsenderId) as! DDXMLElement
            message.addChild(senderid)
            
            //Last time Chat
            //===============================
            //            img.image = UIImage(named: "splash")
            //
            //            let data = UIImageJPEGRepresentation(img.image!, 0.1)
            //            let imageStr = data?.base64EncodedString()
            //            let imageAttachement = DDXMLElement.element(withName: "thread", stringValue: imageStr!) as! DDXMLElement
            //            message.addChild(imageAttachement)
            //===============================
            
            print("message is : \(message)")
   
            appDelegate.xmppStream?.send(message)


            let param : [String : Any] = [
                "receiverId": String(CurrentuserId),
                "senderId": String(CurrentsenderId),
                "receivername": "\(StrlblTitle!)",
                "sendername": "\(UserDefaults.standard.value(forKey: "user_name")!)",
                "isRead": "Yes",
                "type": "outgoing",
                "message": messageStr,
                "timeStemp": timestamp,
                "roaster": " " ,
                "receiverimg": ChatDetail["receiverimg"] as? String,
                "senderimg": Img_url
            ]
            print(param)
            
            txtMessage.text = ""
            if #available(iOS 10.0, *) {
                let chatdata = ChatData(context: appDelegate.coreDataStack.persistentContainer.viewContext)
                chatdata.message = messageStr
                chatdata.isRead = "YES"
                chatdata.receiverId = String(CurrentuserId)
                chatdata.senderId = String(CurrentsenderId)
                chatdata.receivername = "\(StrlblTitle!)"
                chatdata.sendername = "\(UserDefaults.standard.value(forKey: "user_name")!)"
                chatdata.timeStemp = timestamp
                chatdata.type = "outgoing"
                chatdata.roaster = " "
                chatdata.receiverimg = ChatDetail["receiverimg"] as? String
                chatdata.senderimg = Img_url! as String
                
                appDelegate.coreDataStack.saveContext()
            }else
            {
                
                let entity = NSEntityDescription.entity(forEntityName: "ChatData", in: appDelegate.coreDataStack.managedObjectContext)
                let chatdata  = NSManagedObject(entity: entity!, insertInto: appDelegate.coreDataStack.managedObjectContext) as! ChatData
                chatdata.message = messageStr
                chatdata.isRead = "YES"
                chatdata.receiverId = String(CurrentuserId)
                chatdata.senderId = String(CurrentsenderId)
                chatdata.receivername = "\(StrlblTitle!)"
                chatdata.sendername = "\(UserDefaults.standard.value(forKey: "user_name")!)"
                chatdata.timeStemp = timestamp
                chatdata.type = "outgoing"
                chatdata.roaster = " "
                chatdata.receiverimg = ChatDetail["receiverimg"] as? String
                chatdata.senderimg = Img_url! as String
                
                appDelegate.coreDataStack.saveContext()
                
            }
            arrMsg.append(param)
            calculateTimeLabel()
            tableView.reloadData()
            if arrMsg.count > 0
            {
                
                let topIndexPath = IndexPath(row: arrMsg.count - 1, section: 0)
                tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
            }
            self.txtMessage.text = ""
            let userName  =  String(format: "tiller_%@", UserDefaults.standard.string(forKey: "userid")!.lowercased())
            let jabberID = "\(userName)@\(BasePath.hostName)"
            
            if arrMsg.count == 1
            {
                let pre1 = DDXMLElement.element(withName: "presence") as! DDXMLElement
                pre1.addAttribute(withName: "from", stringValue: jabberID)
                pre1.addAttribute(withName: "to", stringValue:  String(format: "%@@%@", CurrentuserId ,BasePath.hostName))
                pre1.addAttribute(withName: "type", stringValue: String(format: "online"))
                let status = DDXMLElement.element(withName: "status", stringValue: "online") as! DDXMLElement
                pre1.addChild(status)
                appDelegate.xmppStream?.send(pre1)
                print(pre1)
            }
        }
    }
    // MARK: - MGSwipeTableCell
     func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        swipeSettings.transition = MGSwipeTransition.border;
        expansionSettings.buttonIndex = 0;
        
        let currentRocd = arrMsg[tableView.indexPath(for: cell)!.row]
        let StrTime = Date(timeIntervalSince1970: Double(currentRocd["timeStemp"] as! String)!).wholedate()
        
        if currentRocd["type"] as! String != "outgoing"
        {
            if direction == MGSwipeDirection.leftToRight {
                
                expansionSettings.fillOnTrigger = false;
                expansionSettings.threshold = 1.1;
                let padding = 15;
                
                let trash = MGSwipeButton(title: StrTime, backgroundColor: UIColor.lightGray, padding: padding, callback: { (cell) -> Bool in
                    // self.deleteMail(self.tableView.indexPath(for: cell)!);
                    return false; //don't autohide to improve delete animation
                });
                
                //            let flag = MGSwipeButton(title: StrTime, backgroundColor: color2, padding: padding, callback: { (cell) -> Bool in
                //                let mail = self.mailForIndexPath(self.tableView.indexPath(for: cell)!);
                //                mail.flag = !mail.flag;
                //                self.updateCellIndicator(mail, cell: cell as! MailTableCell);
                //                cell.refreshContentView(); //needed to refresh cell contents while swipping
                //                return true; //autohide
                //            });
                
                
                return [trash];
            }
        }
        else{
            if direction == MGSwipeDirection.rightToLeft {
                expansionSettings.fillOnTrigger = false;
                expansionSettings.threshold = 1.1;
                return [
                    MGSwipeButton(title: StrTime, backgroundColor: UIColor.lightGray, callback: { (cell) -> Bool in
                        // mail.read = !mail.read;
                        //                    self.updateCellIndicator(mail, cell: cell as! MailTableCell);
                        cell.refreshContentView();
                        // (cell.leftButtons[0] as! UIButton).setTitle("Dhaval left", for: UIControlState());
                        
                        return true;
                    })
                ]
            }

        }
         return [UIView()]
        
    }

    
    
    // MARK: - Chat delegate
    func receivedMessage(param: [String : Any]) {
        
        arrMsg.append(param)
        calculateTimeLabel()
//        loadMessage()
        tableView.reloadData()
        if (self.arrMsg.count > 0)
        {
            let topIndexPath = IndexPath(row: arrMsg.count - 1, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
            
        }
    }


}

//MARK: - ChatUserList cell
class ChatUserListCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnIsOnline: UIButton!
    @IBOutlet weak var btnView: UIButton!

}

//MARK: - ChatUserList cell
class MailTableCell: MGSwipeTableCell
{
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgClock: UIImageView!

    @IBOutlet weak var imgBackground: UIImageView!
}
