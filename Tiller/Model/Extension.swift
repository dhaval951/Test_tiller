//
//  Extension.swift
//  TimeCard
//
//  Created by Sanjay Shah on 24/10/16.
//  Copyright © 2016 Sanjay Shah. All rights reserved.
//

import Foundation
import Alamofire
import SafariServices

//MARK:- API Type
enum APIType: String {
    case OPTIONS , GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}



extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var round: Bool {
        get {
            return false
        }
        set {
            if newValue
            {
                self.layer.borderWidth = 0.0
                self.layer.masksToBounds = false
                self.layer.borderColor = UIColor.white.cgColor
                self.layer.cornerRadius = self.frame.size.height / 2
                self.clipsToBounds = true
            }
        }
    }
    @IBInspectable var dropShadow: UIColor{
//    func dropShadow() {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
//            layer.borderColor = newValue?.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 5
            
//            yourView.layer.shadowColor = UIColor.black.cgColor
//            yourView.layer.shadowOpacity = 1
//            yourView.layer.shadowOffset = CGSize.zero
//            yourView.layer.shadowRadius = 10
//            
//            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//            self.layer.shouldRasterize = true
        }

    }
 }

extension UIViewController: NVActivityIndicatorViewable {
    
    func getComponents(date:Date)-> DateComponents {
        let components = Calendar.current.dateComponents([.day,.month,.year], from: date)
        return components
    }
    func setTextForBlankview(msg : String) -> Void{
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height))
        messageLabel.text = msg
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Helvetica", size: 25.0)
        messageLabel.backgroundColor = UIColor.white
        self.view.addSubview(messageLabel)
    }
    var appDelegate: AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var isReachabel: Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    
    var localTimeZoneIdentifier: String
    {
        return NSTimeZone.local.identifier
    }
    
    var userPref: UserDefaults {
        return UserDefaults.standard
    }
    
    var userId: Int
    {
        return userPref.value(forKey: "userid") as! Int
    }
    
    var UserType: Int
    {
        if userPref.value(forKey: "UserDetail") == nil {
            return 0
        }
         return (userPref.value(forKey: "UserDetail") as! [String : Any])["usertype"] as! Int
    }
    var isLogedin: Bool
    {
        return userPref.value(forKey: "userid") != nil
    }
    
    func addSubtractDaysFromCurrentDate(days: Int) -> Date
    {
        let gregorian : Calendar = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: days, to: Date())!
    }
    
    func getToken() -> String
    {
        let token = UserDefaults.standard.object(forKey: "access_token") as! String
        return token
    }
    
    @IBAction func goBack() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction() {
        toggleLeft()
    }

    //Toast Message Method
    func showMessage(message msg: String)
    {
        var toast: Toast!
        if toast != nil
        {
            toast.cancel()
        }
        toast = Toast(text: msg)
        toast.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toast.show()
    }
    
    //Hud Indicator Method
    func showProgressHud(msg: String)
    {
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: msg, type: NVActivityIndicatorType(rawValue: 0)!, color: #colorLiteral(red: 0.7633545995, green: 0.6108962893, blue: 0.4754495621, alpha: 1))
    }
    
    func hideProgressHud()
    {
        stopAnimating()
    }
    
    func callServiceAll(_ urlString: String, param: [String:Any] = [String: Any](), loaderMessage: String = "", isWithLoading : Bool = true, dataKey: [String] = ["profile_image"],data: [Data] = [Data](), isNeedToken: Bool = false , methods: HTTPMethod = .post, completionHandler: @escaping ([String:Any]) -> ())
    {
        let url = urlString
        let parameter = param
//        let  methodType: HTTPMethod = methods;

        if NetworkReachabilityManager()!.isReachable
        {
            if isWithLoading
            {
                self.showProgressHud(msg: loaderMessage)
            }
            
            if methods == .post
            {
                var response1 : [String:Any]!
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        
                        for (key, value) in parameter
                        {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                        for i in 0..<data.count
                        {
                            multipartFormData.append(data[i], withName: dataKey[i], fileName: "file.jpg", mimeType: "image/png")
                        }
                },
                    to: url,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { result in
                                print(result)
                                print(result.result)
                                if let httpError = result.result.error
                                {
                                    print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                                    print(httpError._code)
                                    if isWithLoading
                                    {
                                        self.hideProgressHud()
                                    }
                                    self.showMessage(message: "Something went wrong. Please try again later.")
                                    let response = [
                                        "message" : "The network connection was lost.",
                                        "status" : false
                                        ] as [String : Any]
                                    completionHandler(response)
                                    
                                }
                                
                                if  result.result.isSuccess
                                {
                                    response1 = result.result.value as! [String:Any]
                                    completionHandler(response1)
                                }
                                
                                if isWithLoading
                                {
                                    self.hideProgressHud()
                                }
                                
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                }
                )
            }
            else
            {
                var response = [String:Any]()
//                var response = String

//                Alamofire.request(url, parameters: parameter)
                
                Alamofire.request(url, method: methods, parameters: parameter)
                    .responseJSON {result in
                        print(result)
                        print(result.result)
                        //self.appDelegate().hideHUD()
                        if let httpError = result.result.error
                        {
                            print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                            print(httpError._code)
                            if isWithLoading
                            {
                                self.hideProgressHud()
                            }
                            self.showMessage(message: "Something went wrong. Please try again later.")
                            let response = [
                                "message" : "The network connection was lost.",
                                "status" : false
                                ] as [String : Any]
                            completionHandler(response)
                            
                        }
                        
                        if  result.result.isSuccess
                        {
                            response = result.result.value as! [String : Any]
                            completionHandler(response)
                        }
                        
                        if isWithLoading
                        {
                            self.hideProgressHud()
                        }
                }
            }
        }
        else
        {
            showMessage(message: ToastMsg.Rechability)
        }
    }
    
    //Menu helper method
    func setNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
}

extension String
{
    func isEmpty() -> Bool
    {
        let strText = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return strText.isEmpty
    }
    
    func Trimming() -> String
    {
        let strText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strText
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}

extension Date {
    func timeAgoSinceDate() -> String {
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: Date())
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let components = calendar.dateComponents(unitFlags, from: date1, to: date2)// components(flags,
        if (components.year! >= 2)
        {
            return "\(components.year!) years ago"
        }
        else if (components.year! >= 1)
        {
            return "1 year ago"
        }
        else if (components.month! >= 2)
        {
            return "\(components.month!) months ago"
        }
        else if (components.month! >= 1)
        {
            return "1 month ago"
        }
        else if (components.weekOfYear! >= 2)
        {
            return "\(components.weekOfYear!) weeks ago"
        }
        else if (components.weekOfYear! >= 1)
        {
            return "1 week ago"
        }
        else if (components.day! > 1 && components.day! < 7)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return "\(dateFormatter.string(from: self))"
        }
        else if (components.day! >= 2)
        {
            return "\(components.day!) days ago"
        }
        else if (components.day! == 1)
        {
            return "Yesterday"
        }
//        else
//        {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
//            return "\(dateFormatter.string(from: self))"
//        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return "\(dateFormatter.string(from: self))"
        }
    }
    
    func wholedate() -> String {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return "\(dateFormatter.string(from: self))"
    }
    func timeAgoSinceDate1() -> String
    {
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: Date())
        
        let unitFlags: Set<Calendar.Component> = [.day]
        //        let flags = NSCalendar.Unit.day
        let components = calendar.dateComponents(unitFlags, from: date1, to: date2)// components(flags, fromDate: date1, toDate: date2, options: [])
        
        if (components.day! >= 7)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM MM, yyyy"
            return "\(dateFormatter.string(from: self))"
        }
        else if (components.day! > 1)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return "\(dateFormatter.string(from: self))"
        }
        else if (components.day! == 1)
        {
            return "Yesterday"
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return "\(dateFormatter.string(from: self))"
        }
    }
    
    func timeAgoSinceDate2() -> String
    {
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: Date())
        
        let unitFlags: Set<Calendar.Component> = [.day]
        //        let flags = NSCalendar.Unit.day
        let components = calendar.dateComponents(unitFlags, from: date1, to: date2)// components(flags, fromDate: date1, toDate: date2, options: [])
        
        if (components.day! >= 7)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM MM, yyyy"
            return "\(dateFormatter.string(from: self))"
        }
        else if (components.day! > 1)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return "\(dateFormatter.string(from: self))"
        }
        else if (components.day! == 1)
        {
            return "Yesterday"
        }
        else
        {
            return "Today"
        }
    }
    func time() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return "\(dateFormatter.string(from: self))"
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: self).uppercased()
    }
    func getDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return dateFormatter.string(from: self).uppercased()
    }
}

extension UITextField
{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.setValue(placeHolderColor, forKeyPath: "   ")
//        }
//    }
    
    func leftImage(_ image: UIImage)
    {
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.contentMode = .left
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height)
        self.leftViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        view.addSubview(imageView)
        self.leftView = view
    }
    
    func rightImage(_ image: UIImage)
    {
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.contentMode = .right
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height)
        self.rightViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        view.addSubview(imageView)
        self.rightView = view
    }
    
    func padding()
    {
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode.always
        
        let paddingRight = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.rightView = paddingRight
        self.rightViewMode = UITextFieldViewMode.always
    }
}

extension UIColor {
    
    convenience init(hex: ColorName) {
        
        let components = (
            R: CGFloat((hex.hashValue >> 16) & 0xff) / 255,
            G: CGFloat((hex.hashValue >> 08) & 0xff) / 255,
            B: CGFloat((hex.hashValue >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
extension UILabel {
    func fadeIn_lbl() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut_lbl() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
extension UIView
{
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func roundView()
    {
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

extension UIImageView
{
    func setImage(url: String, placeHolderImage: String)
    {
        //self.roundView()
//        self.kf.setImage(with: URL(string: url),
//                         placeholder: UIImage(named: placeHolderImage),
//                         options: [.transition(ImageTransition.fade(1))],
//                         progressBlock: { receivedSize, totalSize in
//                            print("\(receivedSize), \(totalSize)")
//        },
//                         completionHandler: { image, error, cacheType, imageURL in
//        })
        
        self.kf.indicatorType = .activity
        
        self.kf.setImage(with: URL(string: url),
                         placeholder: UIImage(named: placeHolderImage),
                         options: [.transition(ImageTransition.fade(1))],
                         progressBlock: { receivedSize, totalSize in
                            print("\(receivedSize), \(totalSize)")
        },
                         completionHandler: { image, error, cacheType, imageURL in
        })
    }
}
extension UICollectionView {
    
    func setTextForBlankTableview(msg : String) -> Void{
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 17, y: 0, width: self.frame.size.width - 34, height: self.frame.size.height))
        messageLabel.text = msg
        messageLabel.textColor = #colorLiteral(red: 0.7561984658, green: 0.603382647, blue: 0.471508503, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18.0)
        self.backgroundView = messageLabel
    }
}
extension UITableView {
    
    // MARK: - UITableView
        func indexPathForView (view : UIView) -> NSIndexPath? {
            let location = view.convert(CGPoint.zero, to:self)
            return indexPathForRow(at: location) as NSIndexPath?
        }

    func setTextForBlankTableview(msg : String) -> Void{
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 17, y: 0, width: self.frame.size.width - 34, height: self.frame.size.height))
        messageLabel.text = msg
        messageLabel.textColor = #colorLiteral(red: 0.7561984658, green: 0.603382647, blue: 0.471508503, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18.0)
        self.backgroundView = messageLabel
    }
    
    func makeFooterView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        
        let activity = UIActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 10, y: 12, width: 20, height: 20))
        activity.color = #colorLiteral(red: 0.7633545995, green: 0.6108962893, blue: 0.4754495621, alpha: 1)
        activity.startAnimating()
        view.addSubview(activity)
        
        self.tableFooterView = view
    }
    
    func removeFooterView() {
        self.tableFooterView = UITableViewHeaderFooterView.init()
    }
}

func fontName()
{
    for family in UIFont.familyNames
    {
        
        print("\(family)")
        
        for name in UIFont.fontNames(forFamilyName: family)
        {
            print("   \(name)")
        }
    }
}
