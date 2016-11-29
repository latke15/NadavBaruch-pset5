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
    private var db: Connection?
    
    private let lists = Table("lists")
    private let notes = Table("notes")
    private let id = Expression<Int>("id")
    private let todo = Expression<String>("todo")
    private let check = Expression<Bool>("check")
    private let title = Expression<String>("title")
    
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
    
    func create(note: String) throws {
        
        let insertLists = lists.insert(self.title <- title)
        let insertNotes = notes.insert(self.todo <- todo, self.check <- check, self.title <- title)
        
        do {
            
            let rowIDLists = try db!.run(insertLists)
            let rowIDNotes = try db!.run(insertNotes)
            print(rowIDLists)
            print(rowIDNotes)
            
        } catch {
            // error handling
            throw error
        }
    }
    
    func read(index: Int, table: String) throws -> String? {
        var result: String?
        var count = 0
        do {
            
            for user in try db!.prepare(table) {
                if table == "lists" {
                    if count == index {
//                        result = user[title]
                    }
                    count += 1
                }
                if table == "notes" {
                    if count == index {
//                        result = user[todo]
                    }
                }
            }
        } catch {
            // error handling
            throw error
            
        }
        return result
    }
    
    func readCheck(index: Int) throws -> Bool? {
        
        var result = false
        var count = 0
        
        do {
            
            for user in try db!.prepare(notes) {
                if count == index {
                    result = user[check]
                }
                count += 1
            }
        } catch {
            // error handling
            throw error
            
        }
        return result
    }
    
    func checkSwitch(index: Int) throws {
        
        var rowID: Int
        var rowCheck: Bool
        rowID = 0
        rowCheck = false
        var count = 0
        
        do {
            for row in try db!.prepare(notes.select(id, check)) {
                if count == index {
                    rowID = (row[id])
                    rowCheck = row[check]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let checkState = notes.filter(id == rowID)
        
        if(rowCheck == false) {
            do {
                print(try db!.run(checkState.update(check <- true)))
            } catch {
                print(error)
            }
        } else {
            do {
                print(try db!.run(checkState.update(check <- false)))
            } catch {
                print(error)
            }
        }
    }
    
    func countRows() throws -> Int? {
        var count = 0
        do {
            
            count = try db!.scalar(notes.select(todo.count))
            
        } catch {
            
            // error handling
            throw error
        }
        return count
        
    }
    
    func deleteRows(index: Int) throws {
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
//            try db!.run(todo.delete())
        } catch {
            print("delete failed: \(error)")
        }
    }
}

