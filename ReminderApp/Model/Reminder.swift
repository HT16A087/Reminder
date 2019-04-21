//
//  Reminder.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

struct Reminder {
    var task: String
    var duedate: String
    
    init(task: String, duedate: String) {
        self.task = task
        self.duedate = duedate
    }
    
    init(from dictionary: Dictionary<String, Any>) {
        self.task = dictionary["task"] as! String
        self.duedate = dictionary["duedate"] as! String
    }
}
