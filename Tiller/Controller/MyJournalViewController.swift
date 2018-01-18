//
//  MyJournalViewController.swift
//  Tiller
//
//  Created by Rohit Parsana on 10/02/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import AVFoundation

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class MyJournalViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance  {
    
    var IsEdit : Bool! = false
    var StrSelectDate : String! = ""
    var SelectedDate : Date!
    var tempDict = [String : Any]()

    @IBOutlet weak var calendar: FSCalendar!
    var arrjournal = [[String: Any]]()

    private let gregorian = Calendar(identifier: .gregorian) as NSCalendar
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
//    @IBOutlet weak var Month: UIScrollView!
//    @IBOutlet weak var Week: UIView!
//    @IBOutlet weak var day: UIView!

    @IBOutlet weak var labelMonthTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMonthTitle()
        self.setNavigationBarItem()
//        self.setTextForBlankview(msg: BasePath.Blankmsg)
//        calendar.dataSource = self
//        calendar.delegate = self
//        calendar.scrollEnabled = false
//        calendar.scopeGesture.isEnabled = true
//        calendar.allowsMultipleSelection = true
//        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
//        calendar.appearance.eventDefaultColor = UIColor.clear
//
//        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
//        calendar.calendarWeekdayView.backgroundColor = UIColor.white
//        calendar.clipsToBounds = true // Remove top/bottom line
//        calendar.firstWeekday = 2 //FSCalendarCellStateToday
////        calendar.appearance.titleTodayColor = UIColor.yellow
    }
    override func viewWillAppear(_ animated: Bool) {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollEnabled = false
        calendar.scopeGesture.isEnabled = true
        calendar.allowsMultipleSelection = true
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.appearance.eventDefaultColor = UIColor.clear
        
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.calendarWeekdayView.backgroundColor = UIColor.white
        calendar.clipsToBounds = true // Remove top/bottom line
        calendar.firstWeekday = 2 //FSCalendarCellStateToday


    }
    override func viewDidDisappear(_ animated: Bool) {
        calendar.removeAllSelecteddate()
        self.calendar.reloadData()

    }
    override func viewDidAppear(_ animated: Bool) {
        self.callservice()
    }
    func callservice()  {

        let param: [String: Any] = [
            "user_id": self.userId ,
            "month": StaticData.arrayMonthCount[UIViewController().getComponents(date: self.calendar.currentPage).month!-1],
            "year": UIViewController().getComponents(date: self.calendar.currentPage).year!
            ]
        print(param)
        
        self.callServiceAll(Path.journalList, param: param,methods : .post, completionHandler: { (result) in
            if result["status"] as! Bool
            {
//                self.showMessage(message: result["message"] as! String)
                self.arrjournal = result.getArrayofDictionary(key: "journalList")//data["data"] as! [[String: Any]]
                let selectdate = NSMutableArray()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for i in 0..<self.arrjournal.count
                {
                    let currentRec = self.arrjournal[i]
                    let date = dateFormatter.date(from: currentRec["noteDate"] as! String)!
                    selectdate.add(date)
                }
                self.calendar.makeAllSelecteddate(selectdate)
                self.calendar.reloadData()
            }
            else{
               // self.showMessage(message: result["message"] as! String)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button action
    @IBAction func btnNewCreateAction(_ sender: UIButton) {
        self.IsEdit = false
        SelectedDate = NSDate() as Date
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "dd/MM/yyyy hh:mm a"
        StrSelectDate = dateFormattor.string(from: NSDate() as Date)
        self.tempDict.removeAll()

        self.performSegue(withIdentifier: "AddNewJornalVC", sender: self)
    }
    
    //MARK: - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool{
        return monthPosition == .current;
    }
    
//        func minimumDate(for calendar: FSCalendar) -> Date {
//            return Date()
//        }
//    
//        func maximumDate(for calendar: FSCalendar) -> Date {
//            let oneYearFromNow =  self.gregorian.date(byAdding: .month, value: 1, to: calendar.currentPage, options: NSCalendar.Options(rawValue: 0))!
//            
//            return oneYearFromNow
//        }
    //Dhaval Changes

//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        if self.gregorian.isDateInToday(date) {
//            return "*"
//        }
//        return nil
//    }
//    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        if self.gregorian.isDateInToday(date) {
//            return "-----"
//        }
//        return nil
//        
//    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        // self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        IsEdit = false
        SelectedDate = date
        StrSelectDate = (self.formatter.string(from: date))
        self.tempDict.removeAll()
        self.performSegue(withIdentifier: "AddNewJornalVC", sender: self)

        print("did select date \(self.formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        IsEdit = true
        SelectedDate = date
        StrSelectDate = (self.formatter.string(from: date))
        self.tempDict.removeAll()

        
        for i in 0..<self.arrjournal.count
        {
            let currentRec = self.arrjournal[i]
            if StrSelectDate == currentRec["noteDate"] as! String {
                self.tempDict = currentRec
                break;
            }
        }

        self.performSegue(withIdentifier: "AddNewJornalVC", sender: self)

        print("did deselect date \(self.formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        //Dhaval Changes
//        if self.gregorian.isDateInToday(date) {
//            return [UIColor.orange]
//        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private functions
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
//        diyCell.circleImageView.isHidden = true;
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current || calendar.scope == .week {
            
            diyCell.eventIndicator.isHidden = false
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            
            diyCell.selectionLayer.isHidden = false
            if selectionType == .middle {
                diyCell.selectionLayer.path = UIBezierPath(rect: diyCell.selectionLayer.bounds).cgPath
            }
            else if selectionType == .leftBorder {
                diyCell.selectionLayer.path = UIBezierPath(roundedRect: diyCell.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: diyCell.selectionLayer.frame.width / 2, height: diyCell.selectionLayer.frame.width / 2)).cgPath
            }
            else if selectionType == .rightBorder {
                diyCell.selectionLayer.path = UIBezierPath(roundedRect: diyCell.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: diyCell.selectionLayer.frame.width / 2, height: diyCell.selectionLayer.frame.width / 2)).cgPath
            }
            else if selectionType == .single {
                let diameter: CGFloat = min(diyCell.selectionLayer.frame.height, diyCell.selectionLayer.frame.width)
                diyCell.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: diyCell.contentView.frame.width / 2 - diameter / 2, y: diyCell.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            }
            
        }
        else if position == .next || position == .previous {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
            diyCell.eventIndicator.isHidden = true
            // Hide default event indicator
            if self.calendar.selectedDates.contains(date) {
                diyCell.titleLabel!.textColor = self.calendar.appearance.titlePlaceholderColor
                // Prevent placeholders from changing text color
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    //MARK: - Functions
    
    func setMonthTitle() {
        self.labelMonthTitle.text = String(format: "%@ %d", arguments:[StaticData.arrayMonth[UIViewController().getComponents(date: self.calendar.currentPage).month!-1],UIViewController().getComponents(date: self.calendar.currentPage).year!]).uppercased()
    }
    
//    func setWeekTitle() {
//        self.labelWeekTitle.text = String(format: "%@ %d - %d %d", arguments:[StaticData.arrayMonth[UIViewController().getComponents(date: selectedWeekStartDate).month!-1],UIViewController().getComponents(date: selectedWeekStartDate).day!,UIViewController().getComponents(date: selectedWeekEndDate).day!,UIViewController().getComponents(date: selectedWeekEndDate).year!])
//    }
//    
//    func setDayTitle() {
//        self.labelDayTitle.text = String(format: "%@ %d %d", arguments:[StaticData.arrayMonth[UIViewController().getComponents(date: selectedDayDate).month!-1],UIViewController().getComponents(date: selectedDayDate).day!,UIViewController().getComponents(date: selectedDayDate).year!])
//    }

    //MARK: button Actions
    
    @IBAction func buttonMonthChangeClicked(_ sender: UIButton) {
        var next:Date
        
        if sender.tag == 1 {
            next = self.gregorian.date(byAdding: .month, value: -1, to: calendar.currentPage, options: NSCalendar.Options(rawValue: 0))!
        } else if sender.tag == 2 {
            next = self.gregorian.date(byAdding: .month, value: 1, to: calendar.currentPage, options: NSCalendar.Options(rawValue: 0))!
        } else if sender.tag == 3 {
            next = self.gregorian.date(byAdding: .year, value: -1, to: calendar.currentPage, options: NSCalendar.Options(rawValue: 0))!
        } else {
            next = self.gregorian.date(byAdding: .year, value: 1, to: calendar.currentPage, options: NSCalendar.Options(rawValue: 0))!
        }
        self.calendar.setCurrentPage(next, animated: true)
        setMonthTitle()
        self.callservice()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddNewJornalVC"
        {
            let destination = segue.destination as! AddNewJornalVC
            destination.IsEdit = IsEdit
            destination.StrDate = StrSelectDate
            destination.SelctedDate = SelectedDate
            
            if (tempDict.count > 0)
            {
                destination.tempDict = tempDict
            }
            
        }
    }


}
