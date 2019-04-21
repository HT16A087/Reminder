//
//  AddReminderViewHeader.swift
//  ReminderApp
//
//  Created by admin on 2019/04/21.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AddReminderHeaderView: UICollectionReusableView {
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a new reminder"
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Bold", size: 28)
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
        
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
