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
    private let id = Expression<Int>("id")
    private let todo = Expression<String?>("todo")
    private let check = Expression<Bool>("check")
    private let title = Expression<String?>("title")
    
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
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            // error handling
            throw error
        }
    }
    
    private func createTable() throws {
        do {
            try db!.run(lists.create(ifNotExists: true) { t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                })
                try db!.run(notes.create(ifNotExists: true) { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(todo)
                    t.column(check)
                    t.column(title)
            } )
        } catch {
            // error handling
            throw error
        }
    }
    
    func createList(todo: String) throws {
        let listNote = ToDoList()
        let insertLists = lists.insert(self.title <- title)
        
        do {
            
            let rowIDLists = try db!.run(insertLists)
            print(rowIDLists)
            
            listNote.listTitle = title
            print("INSERTTEXT",listNote.listTitle.copy())
            ToDoManager.sharedInstance.toDoLists.append(listNote)
            
        } catch {
            // error handling
            throw error
        }
    }
    
    func createNote(todo: String, title: String) throws {
        let item = ToDoItem()
        let insertNotes = notes.insert(self.todo <- todo, self.check <- false, self.title <- title)
        
        do {
        
            let rowIDNotes = try db!.run(insertNotes)
            print(rowIDNotes)
            
            item.title = title
            item.check = false
            item.toDoItem = todo
            ToDoManager.sharedInstance.toDoItem.append(item)
            
            for element in ToDoManager.sharedInstance.toDoLists{
                if element.listTitle == title {
                    element.toDoArray.append(item)
                }
            }
            
        } catch {
            // error handling
            throw error
        }
    }
    
    func readList(index: Int) throws -> String? {
        let result: String?
        var count = 0
        do {
            
            for user in try db!.prepare(lists) {
                    if count == index {
                        result = user[title]
                    }
                    count += 1
            }
        } catch {
            // error handling
            throw error
            
        }
        return result
    }
    
    func read() throws {
    do {
        
        for list in try db!.prepare(lists) {
            
            let listItem = ToDoList()
            
            listItem.listTitle = list[todo]!
            
            for note in try db!.prepare(notes) {
                let toDoItem = ToDoItem()
                
                if listItem.listTitle == note[todo] {
                    toDoItem.toDoItem = note[todo]!
                    toDoItem.check = note[check]
                    toDoItem.title = note[title]!
                    listItem.toDoArray.append(toDoItem)
            }
                
            ToDoManager.sharedInstance.toDoLists.append(listItem)
                
            }
        }
    } catch {
        // error handling
        throw error
    }
        
    func readListID(index: Int) throws -> Int? {
        let result: Int?
        var count = 0
        do {
        
            for user in try db!.prepare(lists) {
                if count == index {
                    result = user[id]
                }
                count += 1
            }
        } catch {
            // error handling
            throw error
                
        }
        return result
    }
    
    func deleteList(index: Int) throws {
        var rowId = Int()
        var rowTitle = String()
        var count = 0
        
        do {
            for checkId in try db!.prepare(lists) {
                if count == index {
                    rowId = checkId[id]
                    rowTitle = checkId[title]!
                }
                count += 1
            }
            let list = lists.filter(id == rowId)
            let note = notes.filter(rowTitle == title)
            
            try db!.run(list.delete())
            try db!.run(note.delete())
            
            ToDoManager.sharedInstance.toDoLists.remove(at: index)
        } catch {
            print("delete failed: \(error)")
        }
    }
        
    func deleteNote(index: Int, title: String) throws {
        var rowId = Int()
        var count = 0
    
        do {
            for checkId in try db!.prepare(notes) {
                if count == index {
                    rowId = checkId[id]
                }
                count += 1
            }
            let note = notes.filter(id == rowId)
        
            try db!.run(note.delete())
        
            for row in ToDoManager.sharedInstance.toDoLists{
                if row.listTitle == title{
                    row.toDoArray.remove(at: index)
                }
            }
            ToDoManager.sharedInstance.toDoLists.remove(at: index)
        } catch {
            print("delete failed: \(error)")
        }
    }
}
}
