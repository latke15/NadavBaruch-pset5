//
//  DatabaseHelper.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    // MARK: SQLite database
    
    // variables
    
    private var db: Connection?
    
    private let lists = Table("lists")
    private let notes = Table("notes")
    
    private let toDoItem = ToDoItem()
    private let toDoList = ToDoList()
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db2.sqlite3")
            try createTable()
        } catch {
            // error handling
            throw error
        }
    }
    
    private func createTable() throws {
        do {
            try db!.run(lists.create(ifNotExists: true) { t in
                
                t.column(toDoList.listID, primaryKey: .autoincrement)
                t.column(toDoList.listTitle, unique: true)
                })
                try db!.run(notes.create(ifNotExists: true) { t in
                    t.column(toDoItem.id, primaryKey: .autoincrement)
                    t.column(toDoItem.toDoItem)
                    t.column(toDoItem.check)
                    t.column(toDoItem.title)
            } )
        } catch {
            // error handling
            throw error
        }
    }
    
    
    func countRows(title: String, tableName: String) throws -> Int {
        do {
            if tableName == "notes" {
                let selection = notes.filter(toDoItem.title == title)
                return try db!.scalar(selection.count)
            } else {
                return try db!.scalar(lists.count)
            }
        } catch {
            throw error
        }
    }
    
    func read(index: Int, title: String, tableName: String) throws -> String? {
        
        var result: String?
        var count = 0
        
        do {
            if tableName == "notes" {
                let selection = notes.filter(toDoItem.title == title)
                for row in try db!.prepare(selection) {
                    if count == index {
                        result = "\(row[toDoItem.toDoItem])"
                    }
                    count += 1
                }
            } else {
                for row in try db!.prepare(lists) {
                    if count == index {
                        result = "\(row[toDoList.listTitle])"
                    }
                    count += 1
                }
            }
        } catch {
            throw error
        }
        
        return result
    }
    
    func readCheck(index: Int, title: String, tableName: String) throws -> Bool {
        
        var result = false
        var count = 0
        
        do {
            let selection = notes.filter(toDoItem.title == title)
            for list in try db!.prepare(selection) {
                if count == index {
                    result = list[toDoItem.check]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return(result)
    }
    
    // MARK: - Modifying tables
    
    func add(item: String, title: String, tableName: String) throws {
        
        var rowID: Int = 0
        
        do {
            if tableName == "notes" {
                rowID = Int(try db!.run(notes.insert(toDoItem.toDoItem <- item, toDoItem.title <- title, toDoItem.check <- false)))
            } else {
                rowID = Int(try db!.run(lists.insert(toDoList.listTitle <- title)))
            }
        } catch {
            print(error)
        }
        
        print(rowID)
        
    }
    
    func checkSwitch(index: Int, title: String) throws {
        
        var rowID: Int
        var rowCheck: Bool
        rowID = 0
        rowCheck = false
        var count = 0
        
        do {
            let selection = notes.filter(toDoItem.title == title)
            for row in try db!.prepare(selection) {
                if count == index {
                    rowID = row[toDoItem.id]
                    rowCheck = row[toDoItem.check]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let rowState = notes.filter(toDoItem.id == rowID)
        
        if(rowCheck == false) {
            do {
                let number = try db!.run(rowState.update(toDoItem.check <- true))
                print("\(number) rows completed")
            } catch {
                print(error)
            }
        } else {
            do {
                let number = try db!.run(rowState.update(toDoItem.check <- false))
                print("\(number) rows uncompleted")
            } catch {
                print(error)
            }
        }
    }
    
    
    func deleteTitle(index: Int, title: String) throws {
        
        var rowID: Int
        rowID = 0
        var count = 0
        
        do {
            let selection = notes.filter(toDoItem.title == title)
            for row in try db!.prepare(selection) {
                if count == index {
                    rowID = row[toDoItem.id]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let title = notes.filter(toDoItem.id == rowID)
        
        do {
            let number = try db!.run(title.delete())
            print("\(number) row deleted")
        } catch {
            print(error)
        }
    }
    
    func deleteList(index: Int) throws {
        var rowID: Int = 0
        var listTitle: String = ""
        var count = 0
        
        do {
            for row in try db!.prepare(lists) {
                if count == index {
                    rowID = row[toDoList.listID]
                    listTitle = row[toDoList.listTitle]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let list = lists.filter(toDoList.listID == rowID)
        let title = notes.filter(toDoItem.title == listTitle)
        
        do {
            let number = try db!.run(list.delete())
            print("\(number) list row deleted")
        } catch {
            print(error)
        }
        
        do {
            let number = try db!.run(title.delete())
            print("\(number) todo row(s) deleted")
        } catch {
            print(error)
        }
        
    }
    
    func selectListname(index: Int) throws -> String? {
        var listTitle: String? = ""
        var count = 0
        
        do {
            for row in try db!.prepare(lists) {
                if count == index {
                    listTitle = row[toDoList.listTitle]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return(listTitle)
}
}
    
