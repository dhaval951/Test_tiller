//
//  ChatData+CoreDataProperties.swift
//  PlayerVacancy
//
//  Created by Dhaval Bhadania on 19/10/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import Foundation
import CoreData


extension ChatData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatData> {
        return NSFetchRequest<ChatData>(entityName: "ChatData");
    }
    @NSManaged public var roaster: String?
    @NSManaged public var receiverimg: String?
    @NSManaged public var senderimg: String?
    @NSManaged public var isRead: String?
    @NSManaged public var message: String?
    @NSManaged public var receiverId: String?
    @NSManaged public var senderId: String?
    @NSManaged public var timeStemp: String?
    @NSManaged public var type: String?
    @NSManaged public var receivername: String?
    @NSManaged public var sendername: String?

}
