//
//  ToDoList.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation

class ToDoList: NSCopying {
    
    var toDoArray = [ToDoItem]()
    var listID = [Int]()
    var listTitle = String()
    
    init() {
        
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ToDoList()
        return copy
    }
    
}
