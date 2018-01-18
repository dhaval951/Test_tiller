//
//  MenuViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 20/12/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import UIKit

// MARK: - Menu Enum
enum LeftMenu: Int {
    //      menuTitle = ["Home","My Profile","Change Password", "My Tribe", "Chat", "Notice Board", "My Journal", "Help Request", "Council Help", "Log Out"]
    case Home
    case MyProfile
    case ChangePassword
    case MyTribe
    case Chat
    case NoticeBoard
    case MyJournal
    case HelpRequest
    case CouncilHelp
    case LogOut

}
// MARK: - Menu Protocol
protocol LeftMenuProtocol : class {
 
    func changeViewController(menu: LeftMenu)
}

// MARK: - Menu Class
class MenuViewController: UIViewController,LeftMenuProtocol {
    internal func changeViewController(menu: LeftMenu) {
        let menu = LeftMenu.RawValue()
        if self.UserType == 2 {
            ParentchangeViewController(menu: menu)
        }
        else if self.UserType == 1{
            ChildchangeViewController(menu: menu)
        }
    }

    
    // MARK: - IBOutlet
//    @IBOutlet weak var lblHeaderTitle: UILabel!
//    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var menuTitle = [String] ()
    
    var loginViewController: UIViewController!
    
    var homeViewController: UIViewController!
    var myProfileViewController: UIViewController!
    var myTribeViewController: UIViewController!
    var childtribeVC: UIViewController!
    var ChatUserListViewController: UIViewController!
    
    var noticeBoardViewController: UIViewController!
    var myJournalViewController: UIViewController!
    var helpRequestViewController: UIViewController!
    var celebrateWithMeVC: UIViewController!
    var legalDocumentVC: UIViewController!

    var councilHelpViewController: UIViewController!
    
    // MARK: - Class Constructor
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.UserType == 2 { //parent
            appDelegate.selectedMenuIndex = 1
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 46
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.UserType == 2  &&  appDelegate.selectedMenuIndex == -1{ //parent
              appDelegate.selectedMenuIndex = 1
        }
        else if self.UserType == 1  &&  appDelegate.selectedMenuIndex == -1
        {
              appDelegate.selectedMenuIndex = 0
        }
        
        if self.UserType == 2 { //parent
            
            menuTitle = ["My Profile",
                         "My Child",
                         "My Journal",
                         "Chat",
                         "Help Request",
                         "Celebrate With Me",
                         "Notice Board",
                         "Change Password",
                         "Council Help",
                         "Legal Documents",
                         "Log Out"]
        }
        else if self.UserType ==  1 //child
        {
            menuTitle = ["Home",
                         "My Profile",
                         "My Tribe",
                         "My Journal",
                         "Chat",
                         "Help Request",
                         "Celebrate With Me",
                         "Notice Board",
                         "Change Password",
                         "Council Help",
                         "Legal Documents",
                         "Log Out"]
        }
        
 
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Change View Controller FOR CHILD
    func ChildchangeViewController(menu: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        switch menu {
        case 0:
            let HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: HomeViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 1:
            let MyProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyProfileViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: MyProfileViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 2:
            let MyTribeViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyTribeViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: MyTribeViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
    
        case 3:
            let MyJournalViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyJournalViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: MyJournalViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 4:
            let ChatUserListViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: ChatUserListViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 5:
            let HelpRequestViewController = mainStoryboard.instantiateViewController(withIdentifier: "HelpRequestViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: HelpRequestViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 6:
            let celebrateWithMeVC = mainStoryboard.instantiateViewController(withIdentifier: "CelebrateWithMeVC")
            appDelegate.navigationController = UINavigationController(rootViewController: celebrateWithMeVC)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
        case 7:
            let NoticeBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: NoticeBoardViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
         
        case 8:
            
            let ChangePasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
            appDelegate.navigationController = UINavigationController(rootViewController: ChangePasswordVC)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break
            
    
        case 9:
            let CouncilHelpViewController = mainStoryboard.instantiateViewController(withIdentifier: "CouncilHelpViewController")
            appDelegate.navigationController = UINavigationController(rootViewController: CouncilHelpViewController)
            self.slideMenuController()?.changeMainViewController(appDelegate.navigationController, close: true)
            break

        case 10:

            let legalDcoumentVC = mainStoryboard.instantiateViewController(withIdentifier: "LegalDocumentVC") as! LegalDocumentVC
            self.appDelegate.navigationController = UINavigationController(rootViewController: legalDcoumentVC)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break

        case 11:
            
            
            let alertController = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                self.CallWebservice_Logout()
       

            }
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                self.slideMenuController()?.closeLeft()
            }
            alertController.addAction(NoAction)
            alertController.addAction(YesAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    // MARK: - Change View Controller FOR parent
    func ParentchangeViewController(menu: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch menu {
            
        case 0:
            let MyProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyProfileViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: MyProfileViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 1:
            let ChildTribeVC = mainStoryboard.instantiateViewController(withIdentifier: "ChildTribeVC")
            self.appDelegate.navigationController = UINavigationController(rootViewController: ChildTribeVC)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 2:
            
            let MyJournalViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyJournalViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: MyJournalViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 3:
            let ChatUserListViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: ChatUserListViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 4:
            let HelpRequestViewController = mainStoryboard.instantiateViewController(withIdentifier: "HelpRequestViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: HelpRequestViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 5:
            let celebrateWithMeVC = mainStoryboard.instantiateViewController(withIdentifier: "CelebrateWithMeVC")
            self.appDelegate.navigationController = UINavigationController(rootViewController: celebrateWithMeVC)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 6:
            let NoticeBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: NoticeBoardViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
        case 7:
            let ChangePasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
            self.appDelegate.navigationController = UINavigationController(rootViewController: ChangePasswordVC)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break
       
        case 8:
            
            let CouncilHelpViewController = mainStoryboard.instantiateViewController(withIdentifier: "CouncilHelpViewController")
            self.appDelegate.navigationController = UINavigationController(rootViewController: CouncilHelpViewController)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break

        case 9:

            let legalDcoumentVC = mainStoryboard.instantiateViewController(withIdentifier: "LegalDocumentVC") as! LegalDocumentVC
            self.appDelegate.navigationController = UINavigationController(rootViewController: legalDcoumentVC)
            self.slideMenuController()?.changeMainViewController(self.appDelegate.navigationController, close: true)
            break

        case 10:
            
            
            let alertController = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
           
                self.CallWebservice_Logout()

//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                self.appDelegate.navigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//                let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//                let slideMenuController = SlideMenuController(mainViewController: self.appDelegate.navigationController, leftMenuViewController: menuViewController, rightMenuViewController: UIViewController())
//                
//                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                
//                // self.navigationController.pushViewController(vc, animated: false)
//                slideMenuController.changeMainViewController(vc, close: true)
//                
//                self.appDelegate.selectedMenuIndex = -1
//                self.appDelegate.disconnect()

            }
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("no")
                self.slideMenuController()?.closeLeft()
                
            }
            alertController.addAction(NoAction)
            alertController.addAction(YesAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }

    
    //MARK:- Button Action
    @IBAction func btnCloseAction(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnCellOptionAction(_ sender: UIButton)
    {
          self.appDelegate.selectedMenuIndex = sender.tag
        let menu = sender.tag
        if self.UserType == 2 {
            ParentchangeViewController(menu: menu)
        }
        else if self.UserType == 1{
            ChildchangeViewController(menu: menu)
        }
        tableView.reloadData()
    }
    
    func CallWebservice_Logout()  {
        let param: [String: Any] = [
            "user_id": self.userId ,
            ]
        print(param)
        self.callServiceAll(Path.getLogout, param: param,methods : .post, completionHandler: { (result) in
            
            print(result)
            if result["status"] as! Bool
            {
                let appDomin = Bundle.main.bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: appDomin!)
                
                self.showMessage(message: result["message"] as! String)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.loginViewController = UINavigationController(rootViewController: loginViewController)
                self.slideMenuController()?.changeMainViewController(self.loginViewController, close: true)
                
                //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                self.appDelegate.navigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                //                let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                //                let slideMenuController = SlideMenuController(mainViewController: self.appDelegate.navigationController, leftMenuViewController: menuViewController, rightMenuViewController: UIViewController())
                //
                //                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                //
                //               // self.navigationController.pushViewController(vc, animated: false)
                //              slideMenuController.changeMainViewController(vc, close: true)
                
                self.appDelegate.selectedMenuIndex = -1
                self.appDelegate.disconnect()
            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })
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

// MARK: - CollectionView Extension
extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.appDelegate.selectedMenuIndex = indexPath.row
        if self.UserType == 2 {
            ParentchangeViewController(menu: indexPath.row)
        }
        else if self.UserType == 1{
            ChildchangeViewController(menu: indexPath.row)
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuTitle[indexPath.row]
        if self.appDelegate.selectedMenuIndex == indexPath.row {
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
        
    }
}
