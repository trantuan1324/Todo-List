//
//  ToDoViewModel.swift
//  TodoList
//
//  Created by Trần Quang Tuấn on 9/8/24.
//

import Foundation
import UIKit

class ToDoViewModel {
    var todoList = [TodoListItem]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() {
        do {
            todoList = try context.fetch(TodoListItem.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func createItem(name: String) {
        let newItem = TodoListItem(context: self.context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("createItem() - \(error)")
        }
    }
    
    func deleteItem(itemPicked deletedItem: TodoListItem) {
        context.delete(deletedItem)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("deleteItem() - \(error)")
        }
    }
    
    func updateItem(itemPicked updatedItem: TodoListItem, updatedName: String) {
        updatedItem.name = updatedName
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("updatedItem() - \(error)")
        }
        
    }
}
