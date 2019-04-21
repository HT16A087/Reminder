//
//  ReminderData.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReminderData {
    
    private let remindersKey = "reminder"
    private let checksKey = "check"
    
    private var reminders = [Reminder]()
    private var checks = [Bool]()
    
    func loadData() {
        let defaults = UserDefaults.standard
        let reminderDics = defaults.object(forKey: remindersKey) as? [Dictionary<String, Any>]
        guard let r = reminderDics else { return }
        for dic in r {
            let reminder = Reminder(from: dic)
            reminders.append(reminder)
        }
    }
    
    func saveData(reminder: Reminder) {
        reminders.append(reminder)
        
        var reminderDics = [Dictionary<String, Any>]()
        for r in reminders {
            let reminderDic: Dictionary<String, Any> = ["task": r.task, "duedate": r.duedate]
            reminderDics.append(reminderDic)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(reminderDics, forKey: remindersKey)
    }
    
    func loadCheck() {
        let defaults = UserDefaults.standard
        guard let checks = defaults.object(forKey: checksKey) as? [Bool] else { return }
        self.checks = checks
    }
    
    func saveCheck(check: Bool) {
        checks.append(check)
        
        let defaults = UserDefaults.standard
        defaults.set(checks, forKey: checksKey)
    }
    
    func changeCheckState(at index: Int) {
        if checks.count > index {
            checks[index] = !checks[index]
        }
        
        let defaults = UserDefaults.standard
        defaults.set(checks, forKey: checksKey)
    }
    
    func deleteData(at index: Int) {
        if reminders.count > index {
            reminders.remove(at: index)
        }
        
        var reminderDics = [Dictionary<String, Any>]()
        for r in reminders {
            let reminderDic: Dictionary<String, Any> = ["task": r.task, "duedate": r.duedate]
            reminderDics.append(reminderDic)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(reminderDics, forKey: remindersKey)
    }
    
    func count() -> Int {
        return reminders.count
    }
    
    func data(at index: Int) -> Reminder? {
        if reminders.count > index {
            return reminders[index]
        }
        return nil
    }
    
    func checkData(at index: Int) -> Bool? {
        if checks.count > index {
            return checks[index]
        }
        return false
    }
}
