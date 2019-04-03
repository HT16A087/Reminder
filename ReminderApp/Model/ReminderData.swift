//
//  ReminderData.swift
//  ReminderApp
//
//  Created by admin on 2019/04/01.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ReminderData {
    
    private let groupId = "group.jp.ac.osakac.cs.hisalab.ReminderApp"
    private let groupKey = "reminder"
    private let checkKey = "check"
    
    private var reminders = [Reminder]()
    
    func loadData() {
        let defaults = UserDefaults(suiteName: groupId)
        let reminderDics = defaults?.object(forKey: groupKey) as? [[String: Any]]
        guard let r = reminderDics else { return }
        for dic in r {
            let reminder = Reminder(from: dic)
            reminders.append(reminder)
        }
    }
    
    func saveData(reminder: Reminder) {
        reminders.append(reminder)
        
        var reminderDics = [[String: Any]]()
        for r in reminders {
            let reminderDic: [String: Any] = ["text": r.text, "duedate": r.duedate, "check": r.check]
            reminderDics.append(reminderDic)
        }
        
        let defaults = UserDefaults(suiteName: groupId)
        defaults?.set(reminderDics, forKey: groupKey)
    }
    
    func deleteData(at index: Int) {
        reminders.remove(at: index)
        
        var reminderDics = [[String: Any]]()
        for r in reminders {
            let reminderDic: [String: Any] = ["text": r.text, "duedate": r.duedate, "check": r.check]
            reminderDics.append(reminderDic)
        }
        
        let defaults = UserDefaults(suiteName: groupId)
        defaults?.set(reminderDics, forKey: groupKey)
    }
    
    func editData(reminder: Reminder, at index: Int) {
        reminders[index] = reminder
        
        var reminderDics = [[String: Any]]()
        for r in reminders {
            let reminderDic: [String: Any] = ["text": r.text, "duedate": r.duedate, "check": r.check]
            reminderDics.append(reminderDic)
        }
        
        let defaults = UserDefaults(suiteName: groupId)
        defaults?.set(reminderDics, forKey: groupKey)
    }
    
    func count() -> Int {
        return reminders.count
    }
    
    func unCheckedCount() -> Int {
        let filter = reminders.filter({$0.check == false})
        let uncheckedCount = filter.count
        return uncheckedCount
    }
    
    func data(at index: Int) -> Reminder? {
        if reminders.count > index {
            return reminders[index]
        }
        return nil
    }
}
