//
//  CoreDataStack.swift
//  PlayerVacancy
//
//  Created by Dhaval Bhadania on 18/10/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import UIKit
import CoreData
class CoreDataStack {
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("path is :%@ ",urls)
        return urls[urls.count-1] as NSURL
    }()
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")

                }
        } else {
            // Fallback on earlier versions
            if managedObjectContext.hasChanges {
                
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Ops there was an error \(error.localizedDescription)")
                    abort()
                }
            }
        }
    }
    
    //==============================
    lazy var managedObjectModel: NSManagedObjectModel = {
        // 1
        let modelURL = Bundle.main.url(forResource: "ChatDataModel", withExtension: "mom")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ChatDataModel.sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the
       // application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to
     //   fail.
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    
    
    //fetch message From Coredata file
    func getMessage(senderId: String, receiverId: String) -> [[String: Any]]  {
        var resultArray = [[String: Any]]()

        if #available(iOS 10.0, *) {
                let fetchRequest = NSFetchRequest<ChatData>(entityName: "ChatData")
                if receiverId != "" {
                    let predicate = NSPredicate(format: "(senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)",senderId,receiverId,receiverId, senderId)
                    fetchRequest.predicate = predicate
                }
                
                do{
                    if let result = try self.persistentContainer.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [ChatData] {
                        for res in result {
                            let result: [String: Any] = [
                                "isRead": res.isRead! as String ,
                                "receiverId": res.receiverId! as String,
                                "senderId": res.senderId! as String ,
                                "receivername": res.receivername! as String,
                                "sendername": res.sendername! as String ,
                                "message": res.message! as String ,
                                "type": res.type! as String ,
                                "timeStemp": res.timeStemp! as String,
                                "roaster": res.roaster! as String ,
                                "receiverimg": res.receiverimg! as String,
                                "senderimg": res.senderimg! as String
                            ]

                            resultArray.append(result)
                        }
                        return resultArray
                    }
                } catch {
                    fatalError("Error Fetching Data")
                }
                
        } else {
            
                let fetchRequest = NSFetchRequest<ChatData>(entityName: "ChatData")
                if receiverId != "" {
                    let predicate = NSPredicate(format: "(senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)",senderId,receiverId,receiverId,senderId)
                    fetchRequest.predicate = predicate
                }

                do{
                    if let result = try self.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [ChatData] {
                        for res in result {
                            let result: [String: Any] = [
                                "isRead": res.isRead! as String ,
                                "receiverId": res.receiverId! as String,
                                "senderId": res.senderId! as String ,
                                "receivername": res.receivername! as String,
                                "sendername": res.sendername! as String ,
                                "message": res.message! as String ,
                                "type": res.type! as String ,
                                "timeStemp": res.timeStemp! as String,
                                "roaster": res.roaster! as String ,
                                "receiverimg": res.receiverimg! as String,
                                "senderimg": res.senderimg! as String
                            ]

                            resultArray.append(result)
                        }
                        return resultArray
                    }
                } catch {
                    fatalError("Error Fetching Data")
                }
        }
        
        return resultArray
    }
    
    //fetch message count
    func getMessageCount() -> Int {
        
        let myId = UserDefaults.standard.string(forKey: "chatusername")
        if #available(iOS 10.0, *) {
            let fetchRequest = NSFetchRequest<ChatData>(entityName: "ChatData")
            let predicate = NSPredicate(format: "(senderId == %@  OR receiverId == %@) AND isRead == 'NO'", myId!, myId!)
            fetchRequest.predicate = predicate
            
            do{
                if let result = try self.persistentContainer.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [ChatData] {
                    
                    return result.count
                }
            } catch {
                fatalError("Error Fetching Data")
            }
            
        } else {
            
            let fetchRequest = NSFetchRequest<ChatData>(entityName: "ChatData")
            let predicate = NSPredicate(format: "(senderId == %@  OR receiverId == %@) AND isRead == 'NO'",myId!, myId!)
            fetchRequest.predicate = predicate
            
            do{
                if let result = try self.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [ChatData] {
                    
                    return result.count
                }
            } catch {
                fatalError("Error Fetching Data")
            }
        }
        
        return 0
    }
    
    
    //fetch message From Coredata file
    func getChatUserlist(senderId: String) -> [[String: Any]]  {
        var resultArray = [[String: Any]]()
        
        if #available(iOS 10.0, *) {
            
            let request = NSFetchRequest<ChatData>(entityName: "ChatData")
            let priceSort = NSSortDescriptor(key: "timeStemp", ascending: false)
            request.sortDescriptors = [ priceSort];
            
            let result = try! self.persistentContainer.viewContext.fetch(request)
            if (!result.isEmpty) {
//                print(result)
                for res in result {
                    let result: [String: Any] = [
                        "isRead": res.isRead! as String ,
                        "receiverId": res.receiverId! as String,
                        "senderId": res.senderId! as String ,
                        "receivername": res.receivername! as String,
                        "sendername": res.sendername! as String ,
                        "message": res.message! as String ,
                        "type": res.type! as String ,
                        "timeStemp": res.timeStemp! as String,
                        "roaster": res.roaster! as String ,
                        "receiverimg": res.receiverimg! as String,
                        "senderimg": res.senderimg! as String
                    ]
                    resultArray.append(result)
                }
                return resultArray
                
            }
            else {
                    //fatalError("Error Fetching Data")
            }


            
        } else {
            
            
            let request = NSFetchRequest<ChatData>(entityName: "ChatData")
            let priceSort = NSSortDescriptor(key: "timeStemp", ascending: false)
            request.sortDescriptors = [ priceSort];
            
            let result = try! self.managedObjectContext.fetch(request)
            if (!result.isEmpty) {
//                print(result)
                for res in result {
                    let result: [String: Any] = [
                        "isRead": res.isRead! as String ,
                        "receiverId": res.receiverId! as String,
                        "senderId": res.senderId! as String ,
                        "receivername": res.receivername! as String,
                        "sendername": res.sendername! as String ,
                        "message": res.message! as String ,
                        "type": res.type! as String ,
                        "timeStemp": res.timeStemp! as String,
                        "roaster": res.roaster! as String ,
                        "receiverimg": res.receiverimg! as String,
                        "senderimg": res.senderimg! as String
                    ]
                    resultArray.append(result)
                }
                return resultArray
                
            }
            else {
                //fatalError("Error Fetching Data")
            }
            
    
    }
        return resultArray
    }

    // Updates a person
    func update(senderId: String){
        
        if #available(iOS 10.0, *) {
            
            let request = NSFetchRequest<ChatData>(entityName: "ChatData")
            let priceSort = NSSortDescriptor(key: "timeStemp", ascending: false)
            request.sortDescriptors = [ priceSort];
            if senderId != "" {
                let predicate = NSPredicate(format: "senderId == %@ OR receiverId == %@ ",senderId,senderId)
                request.predicate = predicate
            }
            let result = try! self.persistentContainer.viewContext.fetch(request)
            if (!result.isEmpty) {
                print(result)
                for res in result {
                    let attribute = res
                    attribute.setValue("YES" , forKey: "isRead")
                }
            }
            (UIApplication.shared.delegate as! AppDelegate).coreDataStack.saveContext()
        } else {
            
            
            let request = NSFetchRequest<ChatData>(entityName: "ChatData")
            let priceSort = NSSortDescriptor(key: "timeStemp", ascending: false)
            request.sortDescriptors = [ priceSort];
            if senderId != "" {
                let predicate = NSPredicate(format: "senderId == %@ OR receiverId == %@ ",senderId,senderId)
                request.predicate = predicate
            }
            let result = try! self.managedObjectContext.fetch(request)
            if (!result.isEmpty) {
                print(result)
                if (!result.isEmpty) {
                    print(result)
                    for res in result {
                        let attribute = res
                        attribute.setValue("YES" , forKey: "isRead")
                    }
                }
            }
            (UIApplication.shared.delegate as! AppDelegate).coreDataStack.saveContext()
        }
    }
}
