//
//  CustomDelegates.swift
//  PlayerVacancy
//
//  Created by Rohit Parsana on 29/09/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import Foundation

protocol AddressDelegate {
     func addressFromMap(address: String, latitude: Double, longitude: Double)
}

protocol SelectSportDelegate {
    func selectedSport(id: Int, sportName: String)
}

protocol ChatDelegate {
    
    func receivedMessage(param: [String: Any])
}
protocol ChatUserDelegate {
    
    func reloadtable()
}
protocol OnlineStatusDelegate {
    
    func onlineUsersList(users: [String])
}
