//
//  RemindCell.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol RemindeCellDelegate: class {
    func changeCellDisplay()
}

class RemindCell: UICollectionViewCell {
    
    weak var delegate: RemindeCellDelegate?
    
    var isSwiched: Bool = false {
        didSet {
            reminderSwitch.isOn = self.isSwiched
        }
    }
    
    fileprivate let reminderLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder me"
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let reminderSwitch: UISwitch = {
        let _switch = UISwitch()
        _switch.isOn = false
        _switch.translatesAutoresizingMaskIntoConstraints = false
        return _switch
    }()
    
    fileprivate let duedateLabel: UILabel = {
        let label = UILabel()
        label.text = "Duedate"
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let duedateButton: UIButton = {
        let button = UIButton(type: .system)
        let now = Date()
        let formatter = DateFormatter()
        button.alpha = 0.0
        button.setTitle(formatter.string(from: now), for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let reminderDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.alpha = 0.0
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupViews()
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - View
    
    fileprivate func setupViews() {
        self.addSubview(reminderLabel)
        self.addSubview(reminderSwitch)
        
        reminderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        reminderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        reminderSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        reminderSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchDidTap(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Layer
    
    fileprivate func setupLayer() {
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
    
    // MARK: - Action
    
    @objc func reminderSwitchDidTap(sender: UISwitch) {
        delegate?.changeCellDisplay()
    }
    
    func getSwitchState() -> Bool {
        return reminderSwitch.isOn
    }
}
