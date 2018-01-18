//
//  AppDelegate.swift
//  Tiller
//
//  Created by Sanjay Shah on 04/01/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import XMPPFramework
import GooglePlacePicker
import GooglePlaces
import GoogleMaps
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate,UNUserNotificationCenterDelegate {
    
    //Last time chat 9657030311
//    var imgChat: UIImage!

    var notificationCount = "0"
    var identifier : String = ""

    var window: UIWindow?
    var mainNavC: UINavigationController!
    var navigationController: UINavigationController!
    var menuViewController: MenuViewController!
    var storyboard: UIStoryboard!
    var userDefault = UserDefaults.standard
    // Chat Xmpp
    var isOpen: Bool = false
    var password: String?
    var xmppStream: XMPPStream?
    var loginServer: String = ""
    var chatUserName: String = ""
    var chatWithUser: String = ""
    var isMessageReceiveInBackground = false
    var ChatUserListViewController: UIViewController!

    var chatDelegate: ChatDelegate?
    var chatUserDelegate: ChatUserDelegate?

    lazy var coreDataStack = CoreDataStack()
    var deviceToken = " "
    //**************************************
    
    var arrOnlineUser = [String]()
    var arrChatuser = [[String : Any]]()
    var onlineUsersDelegate: OnlineStatusDelegate?
    
    //Chat handler things
    var currentChatUser = ""
    var isOnChat = false
    //**************************************


    var selectedMenuIndex = -1

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent

        //Location
        GMSServices.provideAPIKey("AIzaSyD2Y1KnwJ0lkjAYY7BEiaGS4_Q0j_2L820")
        GMSPlacesClient.provideAPIKey("AIzaSyD2Y1KnwJ0lkjAYY7BEiaGS4_Q0j_2L820")
        
        // Override point for customization after application launch.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let slideMenuController = SlideMenuController(mainViewController: self.navigationController, leftMenuViewController: menuViewController, rightMenuViewController: UIViewController())
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController.pushViewController(vc, animated: false)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.sharedManager().enable = true
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    
         //self.writeToFile(data: "didFinishLaunchingWithOptions")
        return true
    }

    
    func registerForRemoteNotification()
    {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if UserDefaults.standard.value(forKey: "userid") != nil
        {
            disconnect()
            self.menuViewController.slideMenuController()?.closeLeft()
        }
          disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    //MARK: - Push Notirfication
    // Remote Notification Methods // <= iOS 9.x
    internal func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        self.deviceToken = deviceTokenString
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let state = UIApplication.shared.applicationState
        print("User Info  didReceiveRemoteNotification= ",userInfo)
        let userData = ((userInfo["aps"] as! [String: Any])["alert"] as! [String: Any])

        let msg = userData["body"] as! String

        print("User Info  didReceiveRemoteNotification= ",userData)


        let category = ((userInfo["aps"] as! [String: Any])["category"] as! String)
       // self.writeToFile(data: "category \(category)")

        
        
        if state == UIApplicationState.inactive
        {
            /*
             {
             "aps":{
             "category":"help_request",
             "alert":{
             "body":"dhaval test has created new help request with you",
             "title":"Hello World!"
             },
             "sound":"newMessage.wav",
             "badge":1
             }
             }
             */
            
            if category == "Chat"
            {
                self.GOTONChat()
            }
            else
            {
                self.GOTONotification()
            }
           // changeController(type)
        }else if state == UIApplicationState.active {
           
            var banner = Banner()
            banner = Banner(title: "Tiller", subtitle: msg, image: UIImage(named: "profile_default_img"), backgroundColor: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), didTapBlock: {
                if category == "Chat"
                {
                    self.GOTONChat()
                }
                else
                {
                    self.GOTONotification()
                 }
            })
      
            banner.springiness = BannerSpringiness.heavy
            banner.show(duration: 3.0)
           
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
        
        
        if (UserDefaults.standard.value(forKey: "userid") != nil)
        {
            _ = connect()
        }
    }
    // MARK: - UNUserNotificationCenter Delegate // >= iOS 10
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        if notification.request.identifier == identifier
        {
            completionHandler( [.alert,.sound,.badge])
        }
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("User Info = ",response.notification.request.content.userInfo)
      //  self.writeToFile(data: "UNUserNotificationCenter User Info = \(response.notification.request.content.userInfo)")

        if response.notification.request.identifier == "Tiller"
        {

            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if self.menuViewController.UserType == 2 { //parent
                self.selectedMenuIndex = 3
                
            }
            else if self.menuViewController.UserType == 1
            {
                self.selectedMenuIndex = 4
            }
            let destController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController") as! ChatUserListViewController

            let topMostController = self.window?.topMostController() as! SlideMenuController
            
            let navigationController = topMostController.mainViewController as! UINavigationController
            //let presentingVC = self.navigationController.topViewController as? ChatUserListViewController

         
            let delayInSeconds = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
                if ((self.navigationController.topViewController as? ChatUserListViewController) == destController) {
                    self.chatUserDelegate?.reloadtable()
                    return;
                }
                navigationController.pushViewController(destController, animated: true)
                self.menuViewController.tableView.reloadData()
            })
        }
        else
        {
            let userInfo = response.notification.request.content.userInfo
            print(userInfo)
            //self.writeToFile(data: "33333UNUserNotificationCenter userInfo apsis = \(userInfo["aps"] as! [String: Any])")
            let category = ((userInfo["aps"] as! [String: Any]).getString(key: "category"))

            if (category == "Chat")
            {
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if self.menuViewController.UserType == 2 { //parent
                    self.selectedMenuIndex = 3
                    
                }
                else if self.menuViewController.UserType == 1
                {
                    self.selectedMenuIndex = 4
                }
                let destController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController") as! ChatUserListViewController
                
                let topMostController = self.window?.topMostController() as! SlideMenuController
                
                let navigationController = topMostController.mainViewController as! UINavigationController
                //let presentingVC = self.navigationController.topViewController as? ChatUserListViewController
                
                
                let delayInSeconds = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
                                    if ((self.navigationController.topViewController as? ChatUserListViewController) == destController) {
                                        self.chatUserDelegate?.reloadtable()
                                        return;
                                    }
                    navigationController.pushViewController(destController, animated: true)
                    self.menuViewController.tableView.reloadData()
                })
            }
            else{
          

          //  let category = ((userInfo["aps"] as! [String: Any])["category"] as! String)

                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if self.menuViewController.UserType == 2 { //parent
                    self.selectedMenuIndex = 3
                }
                else if self.menuViewController.UserType == 1{
                    self.selectedMenuIndex = 4
                }
                let destController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController") as! NoticeBoardViewController
                
                let topMostController = self.window?.topMostController() as! SlideMenuController
                let navigationController = topMostController.mainViewController as! UINavigationController
                let delayInSeconds = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
                    navigationController.pushViewController(destController, animated: true)
                    self.menuViewController.tableView.reloadData()
                })
            }
        }

    }
    

    func changeController(_ type: Int) {
        
        var menuIndex = 0
        
        if type == 0 {
            menuIndex = 2
        }else{
            menuIndex = 3
        }
        
        if let menu = LeftMenu(rawValue: menuIndex) {
            self.selectedMenuIndex = menuIndex
            let delayInSeconds = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
                self.menuViewController.changeViewController(menu: menu)
                // Put your code which should be executed with a delay here
            })
        }
    }
    func GOTONChat() {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if self.menuViewController.UserType == 2 { //parent
            self.selectedMenuIndex = 3

        }
        else if self.menuViewController.UserType == 1
        {
            self.selectedMenuIndex = 4
        }
        let destController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController") as! ChatUserListViewController
        pushViewController(viewController: destController)

    }
    func GOTONotification() {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let NoticeBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController")
//        self.navigationController = UINavigationController(rootViewController: NoticeBoardViewController)
//        self.menuViewController.slideMenuController()?.changeMainViewController(self.navigationController, close: true)

        //var menuIndex = 0
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if self.menuViewController.UserType == 2 { //parent
          //  menuIndex = 6
              self.selectedMenuIndex = 6
           // let NoticeBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController")
           // self.navigationController = UINavigationController(rootViewController: NoticeBoardViewController)
          //  self.menuViewController.slideMenuController()?.changeMainViewController(self.navigationController, close: true)
         //   self.menuViewController.changeViewController(menu: LeftMenu(rawValue: 6)!)
                 //  let destController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController") as! NoticeBoardViewController
        }
        else if self.menuViewController.UserType == 1
        {
        //    menuIndex = 7
           self.selectedMenuIndex = 7
        //    self.menuViewController.changeViewController(menu: LeftMenu(rawValue: 7)!)
        }
        let destController = mainStoryboard.instantiateViewController(withIdentifier: "NoticeBoardViewController") as! NoticeBoardViewController
        pushViewController(viewController: destController)

    }
    //MARK: - Push ViewController Method
    func pushViewController(viewController: UIViewController) {
        let topMostController = self.window?.topMostController() as! SlideMenuController
    
        let navigationController = topMostController.mainViewController as! UINavigationController
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destController = mainStoryboard.instantiateViewController(withIdentifier: "ChatUserListViewController") as! ChatUserListViewController

        if (destController == viewController) {
            return;
        }
        let delayInSeconds = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
            navigationController.pushViewController(viewController, animated: true)
            self.menuViewController.tableView.reloadData()
        })
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if UserDefaults.standard.value(forKey: "userid") != nil
        {
            disconnect()
            self.menuViewController.slideMenuController()?.closeLeft()
        }
    }

    // MARK: - XMPP
    func setupStream () {
        xmppStream = XMPPStream()
        xmppStream?.hostName = BasePath.xmppHostName
        xmppStream?.hostPort = 5222
        xmppStream!.addDelegate(self, delegateQueue: DispatchQueue.main)
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend iq: XMPPIQ!, error: Error!) {
        
        print("error \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!) {
        
        print("error \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend presence: XMPPPresence!, error: Error!) {
        
        print("error \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        
        print("error \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        
        print("error \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        
        print("error \(error)")
    }
    
    func goOffline() {
        
        let presence11 = XMPPPresence(type: "unavailable")
        xmppStream!.send(presence11)
        
        let presence = XMPPPresence(type: "offline")
        xmppStream!.send(presence)
        
        let presence1 = XMPPPresence()
        xmppStream!.send(presence1)

        
    }
    
    func goOnline() {

            print("goOnline")
            let presence1 = XMPPPresence()
            xmppStream!.send(presence1)
            
            let cd = CoreDataStack()
            let chatmsg = cd.getChatUserlist(senderId: "")
    }
    
    func connect() -> Bool {
        
        print("connecting")
        setupStream()
        goOnline()
        //Check Chat Dhaval
        let userName  =  String(format: "tiller_%@", UserDefaults.standard.string(forKey: "userid")!.lowercased())
//        let userName  =  String(format: "danceim_322")

       // let userName = UserDefaults.standard.string(forKey: "userid")!.lowercased()
        let jabberID = "\(userName)@\(BasePath.hostName)"
        let myPassword = userName//"\(UserDefaults.standard.string(forKey: "chatpassword")!)"
        print("jabberID : \(jabberID)" )
        print("myPassword: \(myPassword)")
        
        
        if let stream = xmppStream {
            if !stream.isDisconnected() {
                return true
            }
            
            if jabberID == "" || myPassword == ""{
                print("no jabberID set:" + "\(jabberID)")
                print("no password set:" + "\(myPassword)")
                return false
            }
        
            // stream.myJID = XMPPJID.jidWithString(jabberID)
            stream.myJID = XMPPJID(string: jabberID)
            password = myPassword
            
            let _: NSError?
            do {
                try stream.connect(withTimeout: XMPPStreamTimeoutNone)
                
                return false
                
            }catch{
                print("error is :%@",error)
            }
            
        }
        return true
    }
    
    func disconnect() {
        //if UserDefaults.standard.value(forKey: "userid") != nil
//        {
            goOffline()
             self.xmppStream?.disconnect()
            self.xmppStream?.removeDelegate(self)
        
//        }
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        //    println("xmppStreamDidConnect")
        isOpen = true
        
        do{
            try xmppStream!.authenticate(withPassword: password)
            print("authentification successful")
        }catch{
            print("authentication failed")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("didAuthenticate")
        goOnline()
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!)
    {
        
        if let msg:XMPPMessage = message
        {
            if let messageStr = msg.body()
            {
                if let senderFullId = msg.attribute(forName: "from")!.stringValue
                {
                    let senderId = senderFullId.characters.split {$0 == "@"}.map { String($0) }[0]
                    let receiverId = msg.attribute(forName: "to")!.stringValue!.characters.split {$0 == "@"}.map { String($0) }[0]
                    let subject = msg.subject()!.characters.split {$0 == ","}.map { String($0) }
                    let userName = subject[0]//msg.attribute(forName: "Username")!.stringValue!
                     var userImage = ""
                    if subject.count > 0  {
                        userImage = subject[2]//msg.subject()!
                    }
                    print("message: \(msg)")
                    
                    
                    //Last time chat
//                    let strBase64 = message.thread()
//                    let dataDecoded : Data = Data(base64Encoded: strBase64!, options: .ignoreUnknownCharacters)!
//                    let decodedimage = UIImage(data: dataDecoded)
//                    imgChat = decodedimage
//                    
                    //            <message xmlns="jabber:client" type="chat" to="playerv75@wampserver" Username="Hardik Kansara 123" from="playerv79@wampserver/f1c5c5eb"><body>Hi</body><subject>https:/fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/13413592_1638389383149469_6849130654709525976_n.jpg?oh=ca5e63f73775786a9a7e52b5be717e24&amp;oe=58A6D3D4&amp;__gda__=1486893077_a5cb16d760d2ca320bddfbce64b1d49a</subject><senderid>playerv79</senderid></message>
                    
                    let param : [String: Any] = [
                        "receiverId": String(receiverId),
                        "senderId": String(senderId),
                        "receivername": userName,
                        "sendername": "\(UserDefaults.standard.value(forKey: "user_name")!)",
                        "isRead": "Yes",
                        "type": "incoming",
                        "message": messageStr,
                        "timeStemp": timestamp,
                        "roaster": " " ,
                        "receiverimg": "\(UserDefaults.standard.value(forKey: "user_image")!)",
                        "senderimg": userImage
                    
                    ]
                   // let CurrentsenderId = String(format: "tiller_%@","\(UserDefaults.standard.value(forKey: "userid") as! Int)")
                    
                    //Last time If same device there issue occure have to check device
                   // if receiverId != CurrentsenderId{
                        
                        if #available(iOS 10.0, *)
                        {
                            let chatdata = ChatData(context: coreDataStack.persistentContainer.viewContext)
                            chatdata.message = messageStr
                            chatdata.isRead = (isOnChat && chatUserName == senderId) ? "YES" : "NO"
                            chatdata.receiverId = String(receiverId)
                            chatdata.senderId = String(senderId)
                            chatdata.receivername = "\(UserDefaults.standard.value(forKey: "user_name")!)"
                            chatdata.sendername = userName
                            chatdata.timeStemp = timestamp
                            chatdata.type = "incoming"
                            chatdata.roaster = " "
                            chatdata.receiverimg = "\(UserDefaults.standard.value(forKey: "user_image")!)"
                            chatdata.senderimg = userImage
                            
                            coreDataStack.saveContext()
                        }
                        else
                        {
                            let entity = NSEntityDescription.entity(forEntityName: "ChatData", in: coreDataStack.managedObjectContext)
                            let chatdata  = NSManagedObject(entity: entity!, insertInto: coreDataStack.managedObjectContext) as! ChatData
                            chatdata.message = messageStr
                            chatdata.isRead = (isOnChat && chatUserName == senderId) ? "YES" : "NO"
                            chatdata.receiverId = String(receiverId)
                            chatdata.senderId = String(senderId)
                            chatdata.receivername = "\(UserDefaults.standard.value(forKey: "user_name")!)"
                            chatdata.sendername = userName
                            chatdata.timeStemp = timestamp
                            chatdata.type = "incoming"
                            chatdata.roaster = " "
                            chatdata.receiverimg = "\(UserDefaults.standard.value(forKey: "user_image")!)"
                            chatdata.senderimg = userImage
                            
                            coreDataStack.saveContext()
                        }

                    if isOnChat && chatUserName == senderId
                    {
                        chatDelegate?.receivedMessage(param: param)
                    }
//                    else  if ((self.navigationController.topViewController as? ChatUserListViewController) != nil) {
//                        self.chatUserDelegate?.reloadtable()
//                    }
                    else
                    {
                        if self.isMessageReceiveInBackground
                        {
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let chatViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                            var chatDetail = [String: Any]()
                            chatDetail["receivername"] = userName
                            chatDetail["receiverId"] = senderId
                            chatDetail["receiverimg"] = userImage
                            chatViewController.ChatDetail = chatDetail
                            self.navigationController.pushViewController(chatViewController, animated: true)
                            self.isMessageReceiveInBackground = false
                        }
                        else
                        {
                           
                                if #available(iOS 10.0, *)
                                {
                                    var chatDetail = [String: Any]()
                                    chatDetail["receivername"] = userName
                                    chatDetail["receiverId"] = senderId
                                    chatDetail["receiverimg"] = userImage
                                    //ChatViewController.ChatDetail = chatDetail
                                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let chatViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                                    chatViewController.ChatDetail = chatDetail
                                    
                                    
                                    let content = UNMutableNotificationContent()
                                    identifier = "Tiller"
                                    content.title = userName
                                    content.body =  String(messageStr)
                                    
                                    content.sound = UNNotificationSound.default()
                                    content.userInfo = chatDetail
                                    
                                    let repeatAction = UNNotificationAction(identifier:"Click me",
                                                                            title:"",options:[])
                                    
                                    _ = UNNotificationCategory(identifier: "actionCategory",
                                                               actions: [repeatAction],
                                                               intentIdentifiers: [], options: [])
                                    
                                    
                                    let date = Date()
                                    let calendar = NSCalendar.current
                                    let hour = calendar.component(.hour, from: date as Date)
                                    let minutes = calendar.component(.minute, from: date as Date)
                                    let seconds = calendar.component(.second, from: date as Date)
                                    var date1 = DateComponents()
                                    date1.hour = hour
                                    date1.minute = minutes
                                    date1.second = seconds
                                    date1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                                    
                                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: date1, repeats: true)
                                    let request = UNNotificationRequest(identifier:identifier, content: content, trigger: trigger)
                                    
                                    UNUserNotificationCenter.current().delegate = self
                                    
                                    UNUserNotificationCenter.current().add(request){(error) in
                                        
                                        if (error != nil){
                                            
                                            print(error?.localizedDescription as Any)
                                        }
                                    }
                                    
                                    
                                }
                                else if #available(iOS 9, *)  {
                                    
                                    
                                    var banner = Banner()
                                    banner = Banner(title: "\(userName)", subtitle: "\(messageStr)", image: UIImage(named: "profile_default_img"), backgroundColor: UIColor.lightGray, didTapBlock: {
                                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let chatViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                                        var chatDetail = [String: Any]()
                                        chatDetail["receivername"] = userName
                                        chatDetail["receiverId"] = senderId
                                        chatDetail["receiverimg"] = userImage
                                        chatViewController.ChatDetail = chatDetail
                                        self.navigationController.pushViewController(chatViewController, animated: true)
                                    })
                                    
                                    banner.springiness = BannerSpringiness.heavy
                                    banner.show(duration: 3.0)
                                    
                                }
//                            }
//                            else if state == UIApplicationState.active {
//                                var banner = Banner()
//                                banner = Banner(title: "Tiller", subtitle: messageStr, image: UIImage(named: "profile_default_img"), backgroundColor: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), didTapBlock: {
//                                        self.GOTONChat()
//                                })
//                                banner.springiness = BannerSpringiness.heavy
//                                banner.show(duration: 3.0)
//                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func writeToFile(data: String)
    {
        let file = "\(NSDate().timeIntervalSince1970).txt" //this is the file. we will write to and read from it
        
        let text = "\(data)" //just a text
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent(file);
            
            //writing
            do {
                try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
            
            //            //reading
            //            do {
            //                let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //
            //            }
            //            catch {/* error handling here */}
        }
    }

}

