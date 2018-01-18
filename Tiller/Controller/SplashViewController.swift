//
//  ViewController.swift
//  Refer
//
//  Created by Tarungiri Gosai on 23/09/16.
//  Copyright © 2016 Tarungiri Gosai. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var timer = Timer()
    var arrayImage : [UIImage] = [UIImage(named:"appfy_logo1")!,UIImage(named:"appfy_logo2")!,UIImage(named:"appfy_logo3")!,UIImage(named:"appfy_logo4")!,UIImage(named:"appfy_logo5")!,UIImage(named:"appfy_logo6")!,UIImage(named:"appfy_logo7")!,UIImage(named:"appfy_logo8")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!,UIImage(named:"appfy_logo9")!]
    
    @IBOutlet weak var imageViewLogooAnimation: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewLogooAnimation.animationImages = arrayImage
        imageViewLogooAnimation.animationRepeatCount = 1
        imageViewLogooAnimation.startAnimating()
     //   self.menuContainerViewController.panMode = MFSideMenuPanModeNone
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(SplashViewController.redirectPage), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redirectPage() {
        imageViewLogooAnimation.stopAnimating()
        timer.invalidate()
        if UserDefaults.standard.value(forKey: "userid") != nil {
            _ = self.appDelegate.connect()
            performSegue(withIdentifier: "HomeViewController", sender: self)
        } else {
            performSegue(withIdentifier: "LoginViewController", sender: self)
        }
    }
    
}

