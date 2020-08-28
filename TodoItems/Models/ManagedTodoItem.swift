//
//  ManagedTodoItem.swift
//  TodoItems
//
//  Created by Tomona Sako on 2020/08/28.
//  Copyright © 2020 Derrick Park. All rights reserved.
//

import UIKit
import CoreData

class ManagedTodoItem: NSManagedObject {
    class func findOrCreateSource(matching todoItemInfo: TodoItem, in context: NSManagedObjectContext, priority: Int = 1) throws -> ManagedTodoItem {
        let request: NSFetchRequest<ManagedTodoItem> = ManagedTodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "text = %@", todoItemInfo.text)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                // assert 'sanity': if condition false ... then print message and interrupt program

                assert(matches.count == 1, "ManagedSource.findOrCreateSource -- database inconsistency")
                matches[0].priority = Int16(priority)
                return matches[0]
            }
        } catch {
            throw error
        }
        // no match, instantiate ManagedSource
        let item = ManagedTodoItem(context: context)
        item.text = todoItemInfo.text
        return item
    }
    
    class func getAllResources(in context: NSManagedObjectContext) throws -> [ManagedTodoItem] {
        let request: NSFetchRequest<ManagedTodoItem> = ManagedTodoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]

//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedTodoItem")
        do {
            let items = try context.fetch(request)
            return items
        }catch {
            fatalError()
        }
    }
}
