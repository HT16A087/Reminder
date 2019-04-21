//
//  HeaderView.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReminderHeaderView: UICollectionReusableView {
    
    var reminderNum: Int = 0 {
        didSet {
            let num = self.reminderNum
            reminderNumLabel.text = String(num) + "件"
        }
    }
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminders"
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Bold", size: 32)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let reminderNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.addSubview(headerLabel)
        self.addSubview(reminderNumLabel)
        
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        reminderNumLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        reminderNumLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
