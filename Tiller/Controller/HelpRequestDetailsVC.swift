//
//  HelpRequestDetailsVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 18/04/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class HelpRequestDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView_member: UITableView!

    @IBOutlet weak var tblView_History: UITableView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var HeaderView: UIView!
    var MytribeArray =  [[String : Any]]()

    @IBOutlet weak var btndelete: UIButton!
    var StrID : String = ""

    var DetailDict =  [String : Any]()
    var CommentArray =  [[String : Any]]()

    @IBOutlet weak var txtMessage: NextGrowingTextView!
    @IBOutlet weak var constBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.tableView_member.delegate = self
        self.tableView_member.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.hideKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tblView_History.delegate = self
        self.tblView_History.dataSource = self
        tblView_History.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.4069991438)
        tableView_member.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.4069991438)
        

        // Do any additional setup after loading the view.

        txtMessage.layer.cornerRadius = 4
        txtMessage.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 4, right: 0)
        txtMessage.placeholderAttributedText =
            NSAttributedString(string: "Write a response...",
                               attributes: [NSFontAttributeName: self.txtMessage.font!,
                                            NSForegroundColorAttributeName: UIColor.gray]
        )
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(HelpRequestDetailsVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HelpRequestDetailsVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    
    override func viewWillLayoutSubviews() {

        self.tblView_History.estimatedRowHeight = 80
        self.tblView_History.rowHeight = UITableViewAutomaticDimension
    }
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        self.viewWillTransitionToSize(size: size, withTransitionCoordinator: coordinator)
//        self.layoutTableHeaderView(width: size.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.UserType == 2 {
            btndelete.isHidden = true
        }
        else if self.UserType == 1{
            btndelete.isHidden = false
        }

        self.Fill_data()
        self.layoutTableHeaderView(width: self.view.frame.size.width)
    }
    
    func layoutTableHeaderView(width: CGFloat ) {
        let view = HeaderView! //UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]
        
        let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        
        view.addConstraint(widthConstraint)
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//        view.removeConstraint(widthConstraint)

        view.frame = CGRect(x: 0, y: 0, width: width, height: height )
        view.translatesAutoresizingMaskIntoConstraints = true
        
        self.tblView_History.tableHeaderView = view
        
        
        //===========
//        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView_member.frame.size.width, height: 30))
//        headerView.backgroundColor = UIColor.clear
//        
//        let headerLabel = UILabel(frame: CGRect(x: 55, y: 0,width: tableView_member.frame.size.width - 20, height: 30))
//        headerLabel.text = "My Tribe"
//        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        headerLabel.numberOfLines = 0
//        headerLabel.textAlignment = .center
//        headerLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
//        self.tableView_member.tableHeaderView = headerView

    }
    
    func callServiceAPI()  {
        let param: [String: Any] = [
            "help_id": StrID ,
        ]
        print(param)
        self.callServiceAll(Path.getHelpRequestDetails, param: param,methods : .get, completionHandler: { (result) in
            
            if result["status"] as! Bool
            {
                self.DetailDict = result.getDictionary(key: "helprequest")
                
                let currentRec = self.DetailDict
                self.lblUserName.text = currentRec["helpCreatedby"] as? String
                self.lblDescription.text = currentRec["helpDesc"] as? String
                self.lblTitle.text = currentRec["helpTitle"] as? String
                self.UserImage.setImage(url:currentRec["helpCreatedbyImg"] as! String, placeHolderImage: "profile_default_img")
                self.CommentArray = currentRec["commentList"] as! [[String : Any]]
                self.tblView_History.reloadData()

                self.MytribeArray.append(contentsOf: currentRec.getArrayofDictionary(key: "memberList"))
                
                self.tableView_member.reloadData()
            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })
        
    }
    func Fill_data()  {
        
        
        if StrID.characters.count != 0 {
            self.callServiceAPI()
            return;
        }
        if DetailDict.count > 0
        {
            let currentRec = DetailDict
            lblUserName.text = currentRec["helpCreatedby"] as? String
            lblDescription.text = currentRec["helpDesc"] as? String
            lblTitle.text = currentRec["helpTitle"] as? String
            UserImage.setImage(url:currentRec["helpCreatedbyImg"] as! String, placeHolderImage: "profile_default_img")
            CommentArray = currentRec["commentList"] as! [[String : Any]]

            tblView_History.reloadData()
            
            self.MytribeArray.append(contentsOf: currentRec.getArrayofDictionary(key: "memberList"))
            
            self.tableView_member.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        tblView_History.reloadData()
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                constBottom.constant =  0
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
                   // self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func hideKeyboard(_ sender: UIGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableView_member {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
            headerView.backgroundColor = UIColor.clear
            
            let headerLabel = UILabel(frame: CGRect(x: 55, y: 0,width: tableView.frame.size.width - 20, height: 30))
            headerLabel.text = "MEMBER LIST"
            headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            headerLabel.numberOfLines = 0
            headerLabel.textAlignment = .center
            headerLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
            headerView.addSubview(headerLabel)
            return headerView
        }
        return nil
    }
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView_member {
            return MytribeArray.count
        }
        else
        {
            return CommentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView_member {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mytribe_RequestCell", for: indexPath) as! Mytribe_RequestCell
            let currentRec = MytribeArray[indexPath.row]
            
            cell.lblUserName.text = currentRec["memberName"] as? String
            cell.imgUser.setImage(url:currentRec["memberImg"] as! String, placeHolderImage: "profile_default_img")
            cell.selectionStyle = .none
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.4069991438)

            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelpRequestDetialsCell", for: indexPath) as! HelpRequestDetialsCell
            let currentRec = CommentArray[indexPath.row]
            cell.lblUserName.text = currentRec["commentBy"] as? String
            cell.lblDetails.text = currentRec["commentText"] as? String
            let urlbase = BasePath.urlImgPath
            let urlApend  = currentRec["commentbyImg"] as! String
            let final = urlbase + urlApend
            cell.imgUser.setImage(url:final, placeHolderImage: "profile_default_img")
            
            let a = currentRec["commentDate"] as! String
            let b = currentRec["commentTime"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: a)
            let day = (date?.getDateFormate())!.capitalized
            let last  = day + " " + b.lowercased()
            cell.lblDate.text = last
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear

            return cell
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "HelpRequestDetailsVC", sender: self)
        
    }
    @IBAction  func btnSubmitAction(sender: UIButton) {
        
        if !isReachabel
        {
            showMessage(message: ToastMsg.Rechability)
            return;
        }
        //NOW send message
        txtMessage.text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtMessage.text == "" || txtMessage.text == "Write a response..." || txtMessage.text.characters.count == 0
        {
            self.showMessage(message: "Please write a response.")

            return;
        }
        //NOW send message
        if txtMessage.text != "" && txtMessage.text != "Write a response..." &&  txtMessage.text.characters.count != 0
        {
            txtMessage.text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let messageStr: String = txtMessage.text!
            let Strhelp_id: String = String(DetailDict["helpId"] as! Int64)
            
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "dd/MM/yyyy"
            let Strdate = dateFormattor.string(from: Date())
            
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "hh:mm a"
            let strtime = dateFormatterTime.string(from: Date())
            
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "comment_text" : messageStr,
                "comment_date" : Strdate,
                "comment_time" : strtime,
                "comment_timezone" : self.localTimeZoneIdentifier ,
                "help_id" : Strhelp_id
            ]
            print(param)
            self.callServiceAll(Path.addComment, param: param,methods : .post, completionHandler: { (result) in
                if result["status"] as! Bool
                {
                   // self.showMessage(message: result["message"] as! String)
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showMessage(message: result["message"] as! String)
                }
            })

        }
    }

    // MARK: - Button action
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this Help Request?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
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
                "help_id": "\(self.DetailDict["helpId"] as! Int)", //"\(txtBirthdate.text!)",
            ]
            print(param)
            self.callServiceAll(Path.removeHelprequest, param: param,methods : .post, completionHandler: { (result) in
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
class HelpRequestDetialsCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgClock: UIImageView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var imgBackground: UIImageView!
    
}
