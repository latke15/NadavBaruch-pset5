//
//  ToDoItem.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation
import SQLite

class ToDoItem {
    
    let id = Expression<Int>("ID")
    let toDoItem = Expression<String>("toDoItem")
    let title = Expression<String>("title")
    let check = Expression<Bool>("check")
    
}
