//
//  CouncilHelpViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class CouncilHelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
     var CouncilArray = ["Beyond Blue","Child Council"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CouncilArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouncilCell", for: indexPath) as! CouncilCell
        
        cell.lblUserName.text = CouncilArray[indexPath.row]
        cell.updateConstraintsIfNeeded()
        cell.selectionStyle = .none
        return cell
        
    }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
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
class CouncilCell: UITableViewCell
{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var btnView: UIButton!
}
