//
//  TodoList.swift
//  TodoList
//
//  Created by Derrick Park on 2018-10-11.
//  Copyright © 2018 Derrick Park. All rights reserved.
//

import Foundation
import CoreData

class TodoList {

    var container: NSPersistentContainer!
    
private var todos: [TodoItem] = []
  
  private var highPriorityTodos: [TodoItem] = []
  private var mediumPriorityTodos: [TodoItem] = []
  private var lowPriorityTodos: [TodoItem] = []
  
  enum Priority: Int, CaseIterable {
    case high, medium, low
  }

  init() {
//    let item1 = TodoItem()
//    item1.text = "Take a walk"
//    item1.checked = true
//    let item2 = TodoItem()
//    item2.text = "Study iOS"
//    item2.checked = true
//    let item3 = TodoItem()
//    item3.text = "Update Resume"
//    let item4 = TodoItem()
//    item4.text = "Watch Netflix"
//    let item5 = TodoItem()
//    item5.text = "Study Design pattern"
//    item5.checked = true
//    addTodo(item: item1, for: .high)
//    addTodo(item: item2, for: .medium)
//    addTodo(item: item3, for: .medium)
//    addTodo(item: item4, for: .low)
//    addTodo(item: item5, for: .high)
  }
  
  func todoList(for priority: Priority) -> [TodoItem] {
    switch priority {
      case .high:
        return highPriorityTodos
      case .medium:
        return mediumPriorityTodos
      case .low:
        return lowPriorityTodos
    }
  }
  
  func addTodo(item: TodoItem, for priority: Priority, at index: Int = -1) {
    switch priority {
      case .high:
        if index < 0 {
          highPriorityTodos.append(item)
        } else {
          highPriorityTodos.insert(item, at: index)
      }
      case .medium:
        if index < 0 {
          mediumPriorityTodos.append(item)
        } else {
          mediumPriorityTodos.insert(item, at: index)
      }
      case .low:
        if index < 0 {
          lowPriorityTodos.append(item)
        } else {
          lowPriorityTodos.insert(item, at: index)
      }
    }
    container?.performBackgroundTask{[weak self] context in
        var changeItem = try? ManagedTodoItem.findOrCreateSource(matching: item, in: context)
        changeItem?.checked = item.checked
        try? context.save()
    }
  }
  
  func move(item: TodoItem, from srcPriority: Priority, at srcPath: IndexPath, to destPriority: Priority, at destPath: IndexPath) {
    remove(item: item, from: srcPriority, at: srcPath.row)
    addTodo(item: item, for: destPriority, at: destPath.row)
  }
  
  func remove(item: TodoItem, from priority: Priority, at index: Int) {
    switch priority {
      case .high:
        highPriorityTodos.remove(at: index)
      case .medium:
        mediumPriorityTodos.remove(at: index)
      case .low:
        lowPriorityTodos.remove(at: index)
    }
    container?.performBackgroundTask{[weak self] context in
        let deleteItem = try? ManagedTodoItem.findOrCreateSource(matching: item, in: context)
        context.delete(deleteItem!)
        try? context.save()
    }
  }
  
  private func remove(items: [TodoItem]) {
    for item in items {
      if let index = todos.firstIndex(of: item) {
        todos.remove(at: index)
        container?.performBackgroundTask{[weak self] context in
            let deleteItem = try? ManagedTodoItem.findOrCreateSource(matching: item, in: context)
            context.delete(deleteItem!)
        }
      }
    }
    try? context.save()
  }
}


//private var todos: [TodoItem] = []
//
//
//enum Priority: Int, CaseIterable {
//  case high, medium, low
//}
//
//private var highPriorityTodos: [TodoItem] = []
//private var mediumPriorityTodos: [TodoItem] = []
//private var lowPriorityTodos: [TodoItem] = []
//
//init() {
//  let item1 = TodoItem()
//  item1.text = "Take a walk"
//  item1.checked = true
//  let item2 = TodoItem()
//  item2.text = "Study iOS"
//  item2.checked = true
//  let item3 = TodoItem()
//  item3.text = "Update Resume"
//  let item4 = TodoItem()
//  item4.text = "Watch Netflix"
//  let item5 = TodoItem()
//  item5.text = "Study Design pattern"
//  item5.checked = true
//  addTodo(item: item1, for: .high)
//  addTodo(item: item2, for: .medium)
//  addTodo(item: item3, for: .medium)
//  addTodo(item: item4, for: .low)
//  addTodo(item: item5, for: .high)
//}
//
//func todoList(for priority: Priority) -> [TodoItem] {
//  switch priority {
//    case .high:
//      return highPriorityTodos
//    case .medium:
//      return mediumPriorityTodos
//    case .low:
//      return lowPriorityTodos
//  }
//}
//
//func addTodo(item: TodoItem, for priority: Priority, at index: Int = -1) {
//  switch priority {
//    case .high:
//      if index < 0 {
//        highPriorityTodos.append(item)
//      } else {
//        highPriorityTodos.insert(item, at: index)
//    }
//    case .medium:
//      if index < 0 {
//        mediumPriorityTodos.append(item)
//      } else {
//        mediumPriorityTodos.insert(item, at: index)
//    }
//    case .low:
//      if index < 0 {
//        lowPriorityTodos.append(item)
//      } else {
//        lowPriorityTodos.insert(item, at: index)
//    }
//  }
//}
//
//func move(item: TodoItem, from srcPriority: Priority, at srcPath: IndexPath, to destPriority: Priority, at destPath: IndexPath) {
//  remove(item: item, from: srcPriority, at: srcPath.row)
//  addTodo(item: item, for: destPriority, at: destPath.row)
//}
//
//func remove(item: TodoItem, from priority: Priority, at index: Int) {
//  switch priority {
//    case .high:
//      highPriorityTodos.remove(at: index)
//    case .medium:
//      mediumPriorityTodos.remove(at: index)
//    case .low:
//      lowPriorityTodos.remove(at: index)
//  }
//}
//
//private func remove(items: [TodoItem]) {
//  for item in items {
//    if let index = todos.firstIndex(of: item) {
//      todos.remove(at: index)
//    }
//  }
//}
