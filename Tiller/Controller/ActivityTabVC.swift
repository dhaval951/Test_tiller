//
//  ActivityTabVC.swift
//  Civvy
//
//  Created by Vivek Purohit on 28/08/17.
//  Copyright © 2017 Zealous System. All rights reserved.
//

import UIKit
import ScrollPager

class ActivityTabVC: UIViewController,ScrollPagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    //variable
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var homeViewController: UIViewController!
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableViewAll: UITableView!
    @IBOutlet weak var tableViewFederal: UITableView!
    @IBOutlet weak var tableViewState: UITableView!
    @IBOutlet weak var scrollPager: ScrollPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableViewAll.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableViewFederal.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableViewState.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        
        
        scrollPager.delegate = self
        scrollPager.font = UIFont(name: "Arial", size: 10.0)!
        scrollPager.addSegmentsWithTitlesAndViews(segments: [
            ("ESSENTIALS", tableViewAll),
            ("SGSDG DS", tableViewFederal),
            ("VEGETABLES 2", tableViewState),
            ("XZCBZX BX 3", tableViewState),
            ("INTERNATIONAL VEGETABLES", tableViewState)

            ])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setNavigationBarItem()
    }
    // MARK: - ScrollPagerDelegate -
    
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        print("scrollPager index changed: \(changedIndex)")
    
    }
    
    //MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as! ActivityTableViewCell
        if tableView == tableViewAll {
            
            
            if indexPath.row == 0 {
                cell.imgProfile.image = UIImage(named: "storm.jpg")
                cell.btnName.setTitle("Bill Cliton", for: .normal)
                cell.lblVoted.text = "Voted "
                cell.btnVotedBool.backgroundColor = #colorLiteral(red: 0, green: 0.3711250722, blue: 0.370865941, alpha: 1)
                cell.btnVotedBool.setTitle("YES", for: .normal)
                cell.lblVotedOn.text = " On H.R. 498395"
            }
            else if indexPath.row == 1 {
                cell.imgProfile.image = UIImage(named: "storm.jpg")
                cell.btnName.setTitle("Bill Cliton", for: .normal)
                cell.lblVoted.text = "Voted "
                cell.btnVotedBool.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.9058823529, blue: 0.9294117647, alpha: 1)
                cell.btnVotedBool.setTitleColor(#colorLiteral(red: 0, green: 0.3711250722, blue: 0.370865941, alpha: 1), for: .normal)
                cell.btnVotedBool.setTitle("NO", for: .normal)
                cell.lblVotedOn.text = " On H.R. 498395"
            }
            else if indexPath.row == 2 {
                cell.imgProfile.image = UIImage(named: "storm.jpg")
                cell.btnName.setTitle("Bill Cliton", for: .normal)
                cell.lblVoted.text = ""
                cell.btnVotedBool.setTitleColor(#colorLiteral(red: 0, green: 0.3711250722, blue: 0.370865941, alpha: 1), for: .normal)
                cell.btnVotedBool.setTitle("VETOED", for: .normal)
                cell.btnVotedBool.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.9058823529, blue: 0.9294117647, alpha: 1)
                cell.lblVotedOn.text = " On H.R. 498395"
            }
            else if indexPath.row == 3 {
                cell.imgProfile.image = UIImage(named: "storm.jpg")
                cell.btnName.setTitle("Bill Cliton", for: .normal)
                cell.lblVoted.text = ""
                cell.btnVotedBool.setTitle("SIGNED", for: .normal)
                cell.btnVotedBool.backgroundColor = #colorLiteral(red: 0, green: 0.3711250722, blue: 0.370865941, alpha: 1)
                cell.btnVotedBool.setTitleColor(#colorLiteral(red: 0.8862745098, green: 0.9058823529, blue: 0.9294117647, alpha: 1), for: .normal)
                cell.lblVotedOn.text = " On H.R. 498395"
            }
            //cell.lblAct.text = ""
            
        }else if tableView == tableViewState {
            
            cell.imgProfile.image = UIImage(named: "storm.jpg")
            cell.btnName.setTitle("Bill Cliton", for: .normal)
            cell.lblVoted.text = ""
            cell.btnVotedBool.setTitle("YES", for: .normal)
            cell.lblVotedOn.text = "Text"
            //cell.lblAct.text = ""
           
            
        } else{
            
            cell.imgProfile.image = UIImage(named: "storm.jpg")
            cell.btnName.setTitle("Bill Cliton", for: .normal)
            cell.lblVoted.text = ""
            cell.btnVotedBool.setTitle("YES", for: .normal)
            cell.lblVotedOn.text = "Text"
            //cell.lblAct.text = ""
            
            
        }
        return cell
    }
    
    //MARK:- UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
