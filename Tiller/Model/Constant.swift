//
//  Constant.swift
//  TimeCard
//
//  Created by Sanjay Shah on 24/06/16.
//  Copyright © 2016 Sanjay Shah. All rights reserved.
//

/*
 SUCCESS: {
 message = "Registered successfully";
 status = 1;
 userDetail =     {
 address = bhanvad;
 contactno = 9033782244;
 "device_token" = device123;
 "device_type" = ios;
 dob = "22/02/1973"; 
 email = "dhavalbhadania951@gmail.com";
 fullname = Dhaval;
 gender = 1;
 password = 123456;
 "profile_image" = "";
 userid = 63;
 usertype = 1;
 };
 }
 
 //====
 SUCCESS: {
 message = "Registered successfully";
 status = 1;
 userDetail =     {
 address = "Ahmedabad, Gujarat, India";
 contactno = 9033332416;
 "device_token" = device123;
 "device_type" = ios;
 dob = "09/03/2000";
 email = "dhavalchild@gmail.com";
 fullname = "Dhaval child";
 gender = 2;
 password = 123456;
 "profile_image" = "http://202.131.115.43:8084/Tiller/TillerImages/20170309021009.jpg";
 userid = 103;
 usertype = 2;
 }
 
 
 
 userDetail =     {
 address = "Chandkheda, Ahmedabad, Gujarat, India";
 contactno = 523523;
 "device_token" = device123;
 "device_type" = ios;
 dob = "09/03/2017";
 email = "dhavalap3@gmail.com";
 fullname = dhavalp3;
 gender = 1;
 password = 123456;
 "profile_image" = "";
 userid = 107;
 usertype = 2;
 };
 
 
 //====
 
 userDetail =     {
 address = "Ashton-under-Lyne, UK";
 contactno = 245;
 "device_token" = device123;
 "device_type" = ios;
 dob = "28/01/2017";
 email = "dhaval123@gmail.com";
 fullname = "ffgg asfasfas";
 gender = 1;
 password = 1234567;
 "profile_image" = "http://202.131.115.43:8084/Tiller/TillerImages/20170308115217.jpg";
 userid = 80;
 usertype = 1;
 };
 */

import Foundation
//http://192.168.1.95:8084/Tiller/rest/UserServices/Register

struct BasePath {
    //MARK:- Demo Server URL
    
//    http://202.131.115.43:8084/Tiller/
     static let urlBasePath = "http://202.131.115.43:8080/Tiller/rest/UserServices/"
 //   static let urlBasePath = "http://192.168.1.109:8080/Tiller/rest/UserServices/"
//    static let urlBasePath = "http://202.131.115.43:8084/Tiller/rest/UserServices/"
//     static let urlBasePath = "http://192.168.1.109:8080/Tiller/rest/UserServices/"

    //static let urlBasePath = "http://192.168.1.95:8084/Tiller/rest/UserServices/"
    static let urlImgPath = "http://202.131.115.43:8080/Tiller/TillerImages/"
    
    
    static let Blankmsg = "Coming Soon!"

       //live server
        static let xmppHostName = "192.168.1.93"//"demo.zealousys.com"
        static let hostName = "wampserver"
    
}

//MARK:- Web Service URL
struct Path {
    static let urlRegister            = "\(BasePath.urlBasePath)Register"
    static let urlLogin               = "\(BasePath.urlBasePath)Login"
    static let urlLogout              = "\(BasePath.urlBasePath)logout"
    static let urlForgotPswd          = "\(BasePath.urlBasePath)forgotPassword"
    static let urlChangePswd          = "\(BasePath.urlBasePath)updatePassword"
    static let urlGetProfile          = "\(BasePath.urlBasePath)Profile"
    static let urlEditProfile         = "\(BasePath.urlBasePath)EditProfile"
    static let parentTribeList        = "\(BasePath.urlBasePath)parentTribeList"
    static let childTribeList         = "\(BasePath.urlBasePath)childTribeList"
    static let searchTribeMember      = "\(BasePath.urlBasePath)searchTribeMember"
    static let removeTribeMember      = "\(BasePath.urlBasePath)removeTribeMember"
    static let addTribeMember         = "\(BasePath.urlBasePath)addTribeMember"
    static let addJournal             = "\(BasePath.urlBasePath)addJournal"
    static let editJournal            = "\(BasePath.urlBasePath)editJournal"
    static let removeJournalEntry     = "\(BasePath.urlBasePath)removeJournalEntry"
    static let journalList            = "\(BasePath.urlBasePath)journalList"
    static let helpRequestList        = "\(BasePath.urlBasePath)helpRequestList"
    static let addHelpRequest         = "\(BasePath.urlBasePath)addHelpRequest"
    static let addComment             = "\(BasePath.urlBasePath)addComment"
    static let celebrateList          = "\(BasePath.urlBasePath)celebrateList"
    static let addCelebrate           = "\(BasePath.urlBasePath)addCelebrate"
    static let removeCelebrate        = "\(BasePath.urlBasePath)removeCelebrate"
    static let removeHelprequest      = "\(BasePath.urlBasePath)removeHelprequest"
    static let notificationList       = "\(BasePath.urlBasePath)notificationList"
    static let getHelpRequestDetails  = "\(BasePath.urlBasePath)getHelpRequestDetails"
    static let getCelebrateDetails    = "\(BasePath.urlBasePath)getCelebrateDetails"
    static let getLogout              = "\(BasePath.urlBasePath)logout"

}

//MARK:- Loader Message
struct LoaderMsg {
    static let login                  = "Logging in..."
    static let forgotPassword         = "Sending password..."
    static let register               = "Registering..."
    static let submitProfile          = "Submitting profile details..."
    static let getProfile             = "Getting profile details..."
    static let submitTimecard         = "Submitting timecard..."
    static let getCredential          = "Getting credential details..."
    static let submitCredential       = "Submitting credential details..."
    static let changePassword         = "Updating password..."
    static let getPayCheckHistory     = "Getting pay check details..."
    static let getAvailability        = "Getting availability details..."
    static let submitContact          = "Submitting contact details..."
    static let addShift               = "Submitting shift..."
    static let deleteShift            = "Deleting shift..."
}

//MARK:- Toast Message
struct ToastMsg {
    static let Rechability            = "No internet connection."
    static let connectionLost         = "Something went wrong. Please try again later."
    static let cameraNotAvailabel     = "Camara not available."
    
    static let profileImage           = "Please upload your profile image."
    static let fnameField             = "Please enter first name."
    static let lnameField             = "Please enter last name."
    static let emailField             = "Please enter email address."
    static let emailValid             = "Please enter valid email address."
    static let invalidPswdField       = "Invalid email address or password."
    static let pswdField              = "Please enter your password."
    static let pswdLenght             = "Password should contain minimum 6 characters."
    static let pswdMatch              = "Password and confirm password do not match."
    static let oldPswdNewPswd         = "Old password can not be the same as new password."
    static let termsCondField         = "Please accept terms and conditions."
    static let oldPswdField           = "Please enter your old password."
    static let newPswdField           = "Please enter your new password."
    static let loggedIn               = "Logged in Successfully."
    static let logout                 = "Logout successful."
    static let blankTableView         = "No result found."
    
    static let timeCardImage          = "Please upload time card image."
    static let clientName             = "Please enter client name."
    static let timeCardDate           = "Please select date."
    static let timeCardInTime         = "Please select in time."
    static let timeCardOutTime        = "Please select out time."
    
    static let credentialImage        = "Please upload your credential image."
    static let messageField           = "Please enter message."
    static let subjectField           = "Please enter subject."
    static let phoneField             = "Please enter phone number."
    static let phoneValidField        = "Phone number should be 10 characters."
    
    static let addShiftTime           = "Please enter shift time."
    static let firstShiftInTime       = "Please enter first shift in time."
    static let firstShiftOutTime      = "Please enter first shift out time."
    static let secondShiftInTime      = "Please enter second shift in time."
    static let secondShiftOutTime     = "Please enter second shift out time."
    
    static let firstShiftTimeValid    = "First shift out time should be greater than In time."
    static let secondShiftTimeValid   = "Second shift out time should be greater than In time."
    static let shiftTimeValid         = "Please select proper in-time and out-time for shifts."
    static let futureDateValid        = "You can't add time card entry for future date."
    static let pastDateValid          = "You can't add time card entry for past sixty days."
    static let timeValid              = "Out time should be greater than In time."
}

//MARK:- Color Code
enum ColorName: Int {
    case colorRed                     = 0xc43848
}

struct StaticData {
    static let arrayWeekName  = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    static let arrayMonth = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    static let arrayMonthCount = ["1","2","3","4","5","6","7","8","9","10","11","12"]
}
