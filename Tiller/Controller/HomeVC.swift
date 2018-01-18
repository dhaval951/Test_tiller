//
//  HomeVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 18/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!

    var DetailDict =  [String : Any]()
    var MytribeArray =  [[String : Any]]()
    var CommentArray =  [[String : Any]]()
    var StrID : String = ""
    @IBOutlet weak var collectionView: UICollectionView!

    //display scroolview
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var ViewForscroll: UIView!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.Fill_data()
        self.layoutTableHeaderView(width: self.view.frame.size.width)

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

                self.CommentArray = currentRec["commentList"] as! [[String : Any]]
                self.tableView.reloadData()


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

            CommentArray = currentRec["commentList"] as! [[String : Any]]
            tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        self.scrollView.backgroundColor = UIColor.clear
         self.pageControl.numberOfPages = 4
        // Do any additional setup after loading the view, typically from a nib.
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:ViewForscroll.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
//        textView.textAlignment = .center
//        textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
//        textView.textColor = .black
//        self.startButton.layer.cornerRadius = 4.0
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "Slide 1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "Slide 2")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "Slide 3")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "Slide 4")

        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
      //  self.scrollView.bringSubview(toFront: self.pageControl)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)


    }


    func moveToNextPage (){

        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x

        var slideToX = contentOffset + pageWidth

        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
//        self.pageControl.frame = CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height);
//        self.scrollView.bringSubview(toFront: self.pageControl)
//        self.pageControl.isHidden = false

    }
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        self.pageControl.isHidden = false
        self.scrollView.bringSubview(toFront: self.pageControl)

        // Change the text accordingly
//        if Int(currentPage) == 0{
//            textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
//        }else if Int(currentPage) == 1{
//            textView.text = "I write mobile tutorials mainly targeting iOS"
//        }else if Int(currentPage) == 2{
//            textView.text = "And sometimes I write games tutorials about Unity"
//        }else{
//            textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
//            // Show the "Let's Start" button in the last slide (with a fade in animation)
//            UIView.animate(withDuration: 1.0, animations: { () -> Void in
//                self.startButton.alpha = 1.0
//            })
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.white

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.

    }


    override func viewWillLayoutSubviews() {

        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        self.tableView.tableHeaderView = view


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

    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return CommentArray.count
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
//        headerView.backgroundColor = UIColor.white
//
//        let headerLabel = UILabel(frame: CGRect(x: 55, y: 0,width: tableView.frame.size.width - 150, height: 30))
//        headerLabel.text = "My Tribe"
//        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        headerLabel.numberOfLines = 0
//        headerLabel.textAlignment = .center
//        headerLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
//        headerView.addSubview(headerLabel)
//
//        let AddLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 100, y: 0,width: 100, height: 30))
//        AddLabel.text = "Add"
//        AddLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        AddLabel.numberOfLines = 0
//        AddLabel.textAlignment = .center
//        AddLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
//        headerView.addSubview(AddLabel)
//
//        return headerView
//    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

        cell.selectionStyle = .none
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.tableView.reloadData()

    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
////        headerView.backgroundColor = UIColor.white
////
////        let headerLabel = UILabel(frame: CGRect(x: 55, y: 0,width: tableView.frame.size.width - 150, height: 30))
////        headerLabel.text = "My Tribe"
////        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
////        headerLabel.numberOfLines = 0
////        headerLabel.textAlignment = .center
////        headerLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
////        headerView.addSubview(headerLabel)
////
////        let AddLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 100, y: 0,width: 100, height: 30))
////        AddLabel.text = "Add"
////        AddLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
////        AddLabel.numberOfLines = 0
////        AddLabel.textAlignment = .center
////        AddLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
////        headerView.addSubview(AddLabel)
//
//        return HeaderView
//    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return HeaderView.frame.size.height
//    }

    //MARK: UICollectionview data source method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 7
    }

    //MARK: - UIcollectionviewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        let padding:CGFloat = 40.0
//        let collectionviewCellsize = collectionView.frame.size.width - padding
        return CGSize(width:120, height: 120)
    }

    //MARK: UICollectionview delegate method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CreateCelebrateCollectionCell

        cell.lblName.text = "Essentials"
        //        let currentRec = MytribeArray[indexPath.row]
        //
        //        cell.imgProfile.setImage(url:currentRec["profile_image"] as! String, placeHolderImage: "profile_default_img")
        //        cell.lblName.text = currentRec["fullname"] as? String
        //
        //        cell.btnCheckmark.tag = indexPath.row
        //        cell.btnCheckmark.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
        //        if (self.selectedItems.contains(self.MytribeArray[indexPath.row]["userid"] as! Int ))
        //        {
        //            cell.btnCheckmark.isSelected = true
        //        }else{
        //            cell.btnCheckmark.isSelected = false
        //        }
        cell.btnCheckmark.isHidden = true
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
//        ActivyVC
        self.performSegue(withIdentifier: "ActivyVC", sender: self)

        self.collectionView.reloadData()
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
