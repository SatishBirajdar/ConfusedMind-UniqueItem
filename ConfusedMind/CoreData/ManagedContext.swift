//
//  ManagedContext.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-10-18.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ManagedContext {
//    var appDelegate: AppDelegate
    //1
//    guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//    return
//    }
//
   var options : [NSManagedObject] = []
    
    var managedContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    func setManagedContext() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
         self.managedContext = appDelegate.persistentContainer.viewContext

    }
    
    func fetchOptions() -> [NSManagedObject] {
        
        setManagedContext()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Option")
        
        //3
        do {
            self.options = try self.managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return self.options
    }
    
//    func save(name: String) {
///        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//        
//        let entity =
//            NSEntityDescription.entity(forEntityName: "Item",
//                                       in: managedContext)!
//        
//        let item = NSManagedObject(entity: entity,
//                                   insertInto: managedContext)
//        
//        item.setValue(name, forKeyPath: "name")
//        
//        do {
//            try managedContext.save()
//            items.append(item)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    

    func deleteOptionFromManagedContext(index: Int)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let optionToDelete = options[index]
        
        
//        let itemToDelete = items[indexPath.row]
//        items.remove(at: indexPath.row)
        managedContext.delete(optionToDelete)
        do {
            try managedContext.save()
//            tableView.deleteRows(at: [indexPath], with: .left)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        let itemToDelete = items[index]
////        items.remove(at: index)
//        
//        managedContext.delete(itemToDelete)
//        do {
//            try managedContext.save()
//
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
//    func entityForOptionName(optionName: String) -> NSManagedObject {
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//        
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//        
//        let entity =
//            NSEntityDescription.entity(forEntityName: "Item",
//                                       in: managedContext)!
//        
//        let item = NSManagedObject(entity: entity,
//                                   insertInto: managedContext)
//        
//        
//        
//        item.setValue(optionName, forKeyPath: "name")
//        
//        return item
//    }
//    
//    func saveEntityToManagedObject(){
//        
//    }
    
    func editOptionFromManagedContext(optionName: String ,index: Int){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Option")
        
        do {
            let options = try managedContext.fetch(fetchRequest)
            let optionItem = options[index]
            optionItem.setValue(optionName, forKey: "name")
            
            //save the context
            do {
                try managedContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
}
