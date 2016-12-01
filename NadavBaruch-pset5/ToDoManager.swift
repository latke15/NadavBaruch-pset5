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
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        
    
    }
    
    //Check contents
    func checkContents() {
        for item in toDoLists {
            print("item",item.listTitle)
        }
    }
    
    //Functie die read
    func read() throws {
        do {
            try db!.read()
        } catch {
            throw error
        }
    }
    
    
    //create tablelist
    func insertList(item: String) throws {
        do {
            try db!.createList(todo: item)
        } catch {
            throw error
        }
    }
    
    //create tablenote
    func insertNote(title: String, todo: String) throws {
        
        do {
            try db!.createNote(todo: todo, title: title)
        } catch {
            throw error
        }
        
    }
    
    //delete tablelist
    func deleteList(indexPath: Int) throws {
        do {
            try db!.deleteList(index: indexPath)
        } catch {
            throw error
        }
    }
    
    //delete tablenote
    func deleteDetail(indexPath: Int, title: String) throws {
        do {
            try db!.deleteNote(index: indexPath, title: title)
        } catch {
            throw error
        }
}
}
