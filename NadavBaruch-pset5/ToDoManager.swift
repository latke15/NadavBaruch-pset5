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
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
    
    }
}
