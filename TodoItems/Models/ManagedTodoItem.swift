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
    class func findOrCreateSource(matching todoItemInfo: TodoItem, in context: NSManagedObjectContext) throws -> ManagedTodoItem {
      let request: NSFetchRequest<ManagedTodoItem> = ManagedTodoItem.fetchRequest()
        print(request)
        request.predicate = NSPredicate(format: "text = %@", todoItemInfo.text)
      
      do {
        let matches = try context.fetch(request)
        print(matches)
        if matches.count > 0 {
          // assert 'sanity': if condition false ... then print message and interrupt program
          print("edit")
            assert(matches.count == 1, "ManagedSource.findOrCreateSource -- database inconsistency")
          return matches[0]
        }
      } catch {
        throw error
      }
        print("create")
      // no match, instantiate ManagedSource
      let item = ManagedTodoItem(context: context)
        item.text = todoItemInfo.text
      return item
    }

}
