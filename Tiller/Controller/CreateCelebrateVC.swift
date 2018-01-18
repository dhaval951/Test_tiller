//
//  CreateCelebrateVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 19/04/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class CreateCelebrateVC: UIViewController,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtTitle: UITextField!

    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    

    var selectedItems = NSMutableArray()
    var selectedIndex = -1
    
    var nextPage = false
    var pageNo = 1
    
    var Index: IndexPath!
    var MytribeArray =  [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // txtview.delegate = self
        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedItems.removeAllObjects()
        pageNo = 1
        MytribeArray.removeAll()
        collectionView.reloadData()
        self.callServiceAPI()
        
    }
    func callServiceAPI()  {
        
        
        if self.UserType == 2
        {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "page" : pageNo
            ]
            print(param)
            self.callServiceAll(Path.childTribeList, param: param,methods : .get, completionHandler: { (result) in
                var strmsg : String = ""
                
                if result["status"] as! Bool
                {
                    self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
                    self.collectionView.reloadData()
                    self.pageNo += 1
                    self.nextPage = result["has_next"] as! Bool
                }
                else
                {
                    
                    if (result["has_next"] as! Bool)
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                    strmsg = result["message"] as! String
                }
                if self.MytribeArray.count == 0 {
                    self.collectionView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.collectionView.backgroundView = nil
                }
                self.collectionView.reloadData()
            })
        }
        else if self.UserType == 1
        {
            
            let param: [String: Any] = [
                "user_id": self.userId ,
                "page" : pageNo
            ]
            print(param)
            self.callServiceAll(Path.parentTribeList, param: param,methods : .get, completionHandler: { (result) in
                var strmsg : String = ""
                
                if result["status"] as! Bool
                {
                    //self.showMessage(message: result["message"] as! String)
                    self.MytribeArray.append(contentsOf: result.getArrayofDictionary(key: "list"))
                    
                    self.collectionView.reloadData()
                    self.pageNo += 1
                    self.nextPage = result["has_next"] as! Bool
                }
                else
                {
                    if (result["has_next"] as! Bool)
                    {
                        self.showMessage(message: result["message"] as! String)
                    }
                    strmsg = result["message"] as! String
                }
                if self.MytribeArray.count == 0 {
                    self.collectionView.setTextForBlankTableview(msg: strmsg)
                } else {
                    self.collectionView.backgroundView = nil
                }
                self.collectionView.reloadData()
            })
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        pageNo = 1
//        self.collectionView.estimatedRowHeight = 170
//        self.collectionView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        cell.imgProfile.setImage(url:currentRec["profile_image"] as! String, placeHolderImage: "profile_default_img")
        cell.lblName.text = currentRec["fullname"] as? String
        
        cell.btnCheckmark.tag = indexPath.row
        cell.btnCheckmark.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        if (self.selectedItems.contains(self.MytribeArray[indexPath.row]["userid"] as! Int ))
        {
            cell.btnCheckmark.isSelected = true
        }else{
            cell.btnCheckmark.isSelected = false
        }
        cell.btnCheckmark.isHidden = false
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
        if self.selectedItems.contains(self.MytribeArray[indexPath.row]["userid"] as! Int ) {
            self.selectedItems.remove(self.MytribeArray[indexPath.row]["userid"] as! Int )
        }
        else{
            self.selectedItems.add(self.MytribeArray[indexPath.row]["userid"] as! Int )
        }
        self.collectionView.reloadData()
    }

    func BtnTap(_ sender: UIButton) {
        let value = sender.tag;
        // self.IsVisiblePop_over()
        print(value)
        if self.selectedItems.contains(self.MytribeArray[value]["userid"] as! Int ) {
            self.selectedItems.remove(self.MytribeArray[value]["userid"] as! Int )
        }
        else{
            self.selectedItems.add(self.MytribeArray[value]["userid"] as! Int )
        }
        self.collectionView.reloadData()
    }
    
       @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        //Title validation
        let strTitle1 = txtTitle.text
        let strTitle : String =  (strTitle1?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if ( strTitle.characters.count == 0) {
            self.showMessage(message: "Please Enter Title")
            return;
        }
        
        //Description validation
        let strtxt1 = txtview.text
        var strtxt : String =  (strtxt1?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        if ( strtxt.contains("Enter a description of which")) {
            strtxt = ""
        }
        if strtxt.characters.count == 0{
            self.showMessage(message: "Please write something in description")
            return;
        }
        
        //Mytribe validation
        if self.MytribeArray.count == 0 {
            self.showMessage(message: "Please add tribe memeber first")
            return;
        }
        if self.selectedItems.count == 0 {
            self.showMessage(message: "Please select tribe.")
            return;
        }
        
   
        var stringmember_ids = ""
        if self.selectedItems.count > 0 {
            stringmember_ids = self.selectedItems.componentsJoined(by: ",")
            print(stringmember_ids)
        }
        
        
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "dd/MM/yyyy"
        let Strdate = dateFormattor.string(from: Date())
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "hh:mm a"
        let strtime = dateFormatterTime.string(from: Date())
        
    
        let param: [String: Any] = [
            "user_id": self.userId ,
            "celebrate_title":strTitle,
            "celebrate_desc":strtxt ,
            "celebrate_time":strtime ,
            "celebrate_date":Strdate ,
            "celebrate_timezone":self.localTimeZoneIdentifier ,
            "member_ids":stringmember_ids ,
            ]
        
        self.callServiceAll(Path.addCelebrate, param: param,methods : .post, completionHandler: { (result) in
            
            if result["status"] as! Bool
            {
                self.showMessage(message: result["message"] as! String)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.showMessage(message: result["message"] as! String)
            }
        })
        
        
    }
    // MARK: - UITextView delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter a description of which you're celebrating"
        {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        if updatedString?.characters.count == 0 {
            textView.text = "Enter a description of which you're celebrating"
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        if (updatedString?.contains("Enter a description of which"))! {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        // let updatedString = (textView.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)
        
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
//MARK: -UIcollectionview custome cell

class CreateCelebrateCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheckmark: UIButton!

    
}
