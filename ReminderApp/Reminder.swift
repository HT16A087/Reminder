//
//  Task.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct Reminder {
    let text: String
    let duedate: String
    let check: Bool
    
    init(text: String, duedate: String, check: Bool) {
        self.text = text
        self.duedate = duedate
        self.check = check
    }
    
    init(from dictionary: [String: Any]) {
        self.text = dictionary["text"] as! String
        self.duedate = dictionary["duedate"] as! String
        self.check = dictionary["check"] as! Bool
    }
}
