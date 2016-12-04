//
//  ToDoManager.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation

class ToDoManager {
    static let sharedInstance = ToDoManager()
    
    /// database
    private let db = DatabaseHelper()
    
    // array of the todo-lists
    var toDoLists = [ToDoList]()
    var toDoItems = [ToDoItem]()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        
        if db == nil {
            print("error")
        }
    
    }
    
    func count(title: String, tableName: String) -> Int {
        
        var count: Int = 0
        
        do {
            count = try db!.countRows(title: title, tableName: tableName)
        } catch {
            print(error)
        }
        
        return(count)
    }
    
    func write(toDoItem: String, title: String, tableName: String) {
        do {
            try db!.add(toDoItem: toDoItem, title: title, tableName: tableName)
        } catch {
            print(error)
        }
    }
    
    func read(index: Int, title: String, tableName: String) -> (String?, Bool) {
        
        var title: String? = ""
        var completed: Bool = false
        
        do {
            title = try db!.populate(index: index, title: title!, tableName: tableName)
            completed = try db!.populateCompleted(index: index, title: title!, tableName: "notes")
        } catch {
            print(error)
        }
        
        return(title, completed)
    }
    
    func delete(index: Int, title: String, tableName: String) {
        do {
            if tableName == "notes" {
                try db!.deleteTitle(index: index, title: title)
            } else {
                try db!.deleteList(index: index)
            }
        } catch {
            print(error)
        }
    }
    
    func selectListname(index: Int) -> String? {
        
        var listname: String? = ""
        
        do {
            listname = try db!.selectListname(index: index)
        } catch {
            print(error)
        }
        
        return(listname)
        
    }
    
    func completedSwitch(index: Int, title: String) {
        do {
            try db!.completedSwitch(index: index, title: title)
            print("index \(index), title \(title)")
        } catch {
            print(error)
        }
    }}
