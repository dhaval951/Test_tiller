//
//  LegalDocumentVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 30/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class LegalDocumentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let arrayString = ["Privacy Policy", "Terms & Conditions", "EULA Document"]
    let arrayFile = ["PrivacyPolicy", "TermsAndCondition", "EULA"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView.init()
        self.setNavigationBarItem()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayString.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let label = cell.viewWithTag(100) as! UILabel
        label.text = arrayString[indexPath.row]

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueFromLegalDocumentToOpenPdfFile", sender: indexPath.row)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromLegalDocumentToOpenPdfFile" {
            let destController = segue.destination as! OpenPdfFileVC
            destController.strFileName = arrayFile[sender as! Int]
            destController.strTitle = arrayString[sender as! Int]
        }
    }
}
