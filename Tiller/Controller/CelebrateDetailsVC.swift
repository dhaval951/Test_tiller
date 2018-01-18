//
//  CelebrateDetailsVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 19/04/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class CelebrateDetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btndelete: UIButton!

    @IBOutlet weak var Imguser: UIImageView!
    var DetailDict =  [String : Any]()
    var StrID : String = ""
    var MytribeArray =  [[String : Any]]()
    var pageNo = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.UserType == 2 {
            btndelete.isHidden = true
        }
        else if self.UserType == 1{
            btndelete.isHidden = false
        }
        
        self.Fill_data()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callServiceAPI()  {
        let param: [String: Any] = [
        "celebrate_id": StrID
            ]
        print(param)
        self.callServiceAll(Path.getCelebrateDetails, param: param,methods : .get, completionHandler: { (result) in
            
            if result["status"] as! Bool
            {
                  self.DetailDict = result.getDictionary(key: "celebrate")
                let currentRec = self.DetailDict
                self.lblName.text = currentRec["createdBy"] as? String
                self.txtview.text = currentRec["celebDsc"] as? String
                self.txtTitle.text = currentRec["celebTitle"] as? String
                self.Imguser.setImage(url:currentRec["createdbyImg"] as! String, placeHolderImage: "profile_default_img")
                self.MytribeArray.append(contentsOf: currentRec.getArrayofDictionary(key: "memberList"))
//                 let strmsg = result["message"] as! String
//
//                if self.MytribeArray.count == 0 {
//                    self.collectionView.setTextForBlankTableview(msg: strmsg)
//                } else {
//                    self.collectionView.backgroundView = nil
//                }
                self.collectionView.reloadData()

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
            lblName.text = currentRec["createdBy"] as? String
            txtview.text = currentRec["celebDsc"] as? String
            txtTitle.text = currentRec["celebTitle"] as? String
            Imguser.setImage(url:currentRec["createdbyImg"] as! String, placeHolderImage: "profile_default_img")
            
            self.MytribeArray.append(contentsOf: currentRec.getArrayofDictionary(key: "memberList"))
            
            self.collectionView.reloadData()
         }
    }
    
    //MARK: UICollectionview data source method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return MytribeArray.count
    }
    
    //MARK: - UIcollectionviewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding:CGFloat = 40.0
        let collectionviewCellsize = collectionView.frame.size.width - padding
        return CGSize(width: collectionviewCellsize/2, height: collectionviewCellsize/2)
    }
    
    //MARK: UICollectionview delegate method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CreateCelebrateCollectionCell
        
        let currentRec = MytribeArray[indexPath.row]
        
        cell.imgProfile.setImage(url:currentRec["memberImg"] as! String, placeHolderImage: "profile_default_img")
        cell.lblName.text = currentRec["memberName"] as? String
       
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
 
        self.collectionView.reloadData()
    }
    
  

    // MARK: - Button action
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this Celebrate", message: "", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("no")
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            let param: [String: Any] = [
                "celebrate_id": "\(self.DetailDict["celebId"] as! Int)" //"\(txtBirthdate.text!)",
            ]
            print(param)
            self.callServiceAll(Path.removeCelebrate, param: param,methods : .post, completionHandler: { (result) in
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
