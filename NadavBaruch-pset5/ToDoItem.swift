//
//  ToDoItem.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation

class ToDoItem: NSCopying {
    
    var toDoItem = String()
    var title = String()
    var check = Bool()
    
    init() {
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ToDoItem()
        return copy
    }
    
}
