//
//  HeaderView.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReminderHeaderView: UICollectionReusableView {
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminders"
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let reminderCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0件"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(headerLabel)
        addSubview(reminderCountLabel)
        
        // Reminder の件数を表示
        let reminderCountStr: String = String(reminderCount())
        reminderCountLabel.text = reminderCountStr + "件" // 0件
        
        // Constraints
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: reminderCountLabel.leftAnchor, constant: -8).isActive = true
        
        reminderCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        reminderCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        reminderCountLabel.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        
        // Setup Notification
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(reminderCountLabelUpdate(notification:)), name: .reminderCountLabelUpdate, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reminderCount() -> Int {
        // Reminder の件数を取得
        let reminderData = ReminderData()
        reminderData.loadData()
        return reminderData.count()
    }
    
    // MARK: - NSNotification
    
    @objc func reminderCountLabelUpdate(notification: NSNotification) {
        // Reminder の件数を表示
        let reminderCountStr: String = String(reminderCount())
        reminderCountLabel.text = reminderCountStr + "件" // 0件
    }
}

// MARK: - NSNotification Name

extension NSNotification.Name {
    static let reminderCountLabelUpdate = Notification.Name("reminderCountLabelUpdate")
}
