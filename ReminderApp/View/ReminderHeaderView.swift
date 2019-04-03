//
//  HeaderView.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReminderHeaderView: UICollectionReusableView {
    
    fileprivate var reminderData: ReminderData!
    
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
        
        setupViews()
        setupReminderCountLabel()
        
        setupNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(headerLabel)
        addSubview(reminderCountLabel)
        
        // Constraints
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: reminderCountLabel.leftAnchor, constant: -8).isActive = true
        
        reminderCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        reminderCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        reminderCountLabel.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
    }
    
    func setupReminderCountLabel() {
        uncheckedReminderCount()
    }
    
    func setupNotification() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(reminderCountLabelUpdate(notification:)), name: .reminderCountLabelUpdate, object: nil)
    }
    
    func uncheckedReminderCount() {
        reminderData = ReminderData()
        reminderData.loadData()
        let uncheckedCount = reminderData.unCheckedCount()
        let uncheckedCountStr = String(uncheckedCount)
        reminderCountLabel.text = uncheckedCountStr + "件"
    }
    
    // MARK: - NSNotification
    
    @objc func reminderCountLabelUpdate(notification: NSNotification) {
        uncheckedReminderCount()
    }
}

// MARK: - NSNotification Name

extension NSNotification.Name {
    static let reminderCountLabelUpdate = Notification.Name("reminderCountLabelUpdate")
}
