//
//  ReminderCell.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol ReminderCellDelegate: class {
    func check(cell: ReminderCell)
    func delete(cell: ReminderCell)
}

class ReminderCell: UICollectionViewCell {
    
    weak var delegate: ReminderCellDelegate?
    
    var dataSorceItem: Any? {
        didSet {
            guard let reminder = self.dataSorceItem as? Reminder else { return }
            taskLabel.text = reminder.task
            print(reminder.duedate)
            if reminder.duedate != "" {
                dueLabel.text = changeDateFormat(duedate: reminder.duedate)
            }
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.alpha = 0.0
            UIView.animate(withDuration: 0.2) { self.deleteButton.alpha = 1.0 }
            deleteButton.isHidden = !self.isEditing
            
            checkButton.isHidden = self.isEditing
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            if self.isChecked == true {
                checkCell()
            } else {
                uncheckCell()
            }
        }
    }
    
    fileprivate let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "deleteImage")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.red
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let dueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 10)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.addSubview(checkButton)
        self.addSubview(deleteButton)
        self.addSubview(taskLabel)
        self.addSubview(dueLabel)
        
        checkButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        deleteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        taskLabel.leftAnchor.constraint(equalTo: checkButton.rightAnchor, constant: 8).isActive = true
        taskLabel.rightAnchor.constraint(equalTo: dueLabel.leftAnchor, constant: -8).isActive = true
        taskLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        dueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dueLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        checkButton.addTarget(self, action: #selector(checkButtonDidTap(sender:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Layer
    
    private func setupLayer() {
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
        
        let gradLayer = CAGradientLayer()
        gradLayer.frame = CGRect(x: 0, y: -3, width: self.frame.width, height: 3)
        gradLayer.colors = [ UIColor.magenta.cgColor, UIColor.blue.cgColor ]
        gradLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradLayer.cornerRadius = 3.0
        self.layer.insertSublayer(gradLayer, at: 0)
    }
    
    // MARK: - Action
    
    @objc func checkButtonDidTap(sender: Any) {
        delegate?.check(cell: self)
    }
    
    @objc func deleteButtonDidTap(sender: Any) {
        delegate?.delete(cell: self)
    }
}

extension ReminderCell {
    
    // MARK: - DateFormatter
    
    private func changeDateFormat(duedate: String) -> String {
        // change dateformat
        let dateFormatte = DateFormatter()
        dateFormatte.dateStyle = .medium
        dateFormatte.timeStyle = .short
        let date = dateFormatte.date(from: duedate)
        
        // create date
        dateFormatte.timeStyle = .none
        dateFormatte.doesRelativeDateFormatting = true
        let dateStr = dateFormatte.string(from: date!)
        
        // create time
        dateFormatte.dateStyle = .none
        dateFormatte.timeStyle = .short
        dateFormatte.doesRelativeDateFormatting = false
        let timeStr = dateFormatte.string(from: date!)
        
        // create duedate
        let duedateStr = dateStr + "\n" + timeStr
        return duedateStr
    }
    
    // MARK: - Button
    
    private func checkCell() {
        let checkImage = UIImage(named: "checkImage")
        checkButton.setImage(checkImage, for: .normal)
        
        taskLabel.textColor = UIColor.lightGray
        dueLabel.textColor = UIColor.lightGray
    }
    
    private func uncheckCell() {
        let uncheckImage = UIImage(named: "uncheckImage")
        checkButton.setImage(uncheckImage, for: .normal)
        
        taskLabel.textColor = UIColor.black
        dueLabel.textColor = UIColor.black
    }
}
